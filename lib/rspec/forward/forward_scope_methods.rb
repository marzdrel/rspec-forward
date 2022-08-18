module ::RSpec
  module Forward
    module ForwardScopeMethods
      using CoreExtensions

      def exp_args(actual)
        return [actual, *@args] if @with_parent_arg
        return [no_args] if @args.size.zero? && @kwargs.size.zero?

        @args
      end

      def find_actual(klass_or_instance)
        if klass_or_instance.is_a? Class
          klass_or_instance
        else
          klass_or_instance.class
        end
      end

      def matches_for?(klass_or_instance)
        actual = find_actual(klass_or_instance)

        method_name = @expected
        base_klass = format("%<method>s_scope", method: method_name.to_s).camelize
        @scope_klass_name ||= format("%s::%s", actual.to_s, base_klass)


        begin
          @scope_klass = Object.const_get(@scope_klass_name)
        rescue NameError => e
          failure_scope_klass_name_not_defined(@scope_klass_name)
          return false
        end

        allow(@scope_klass)
          .to receive(@target_method_name)
          .and_return(:result)

        if @kwargs.any?
          result = klass_or_instance.public_send(method_name, *@args, **@kwargs) == :result

          expect(@scope_klass)
            .to have_received(@target_method_name)
            .with(*exp_args(actual), **@kwargs)
        else
          result = klass_or_instance.public_send(method_name, *@args) == :result

          expect(@scope_klass)
            .to have_received(@target_method_name)
            .with(*exp_args(actual))
        end

        result
      end

      def failure_scope_klass_name_not_defined(name)
        @failure_message = "#{name} should be defined"
        @failure_message_when_negated = "#{name} should be defined"
      end

      def failure_message
        @failure_message ||
          %Q(expected "#{@target}.call" to be invoked)
      end

      def failure_message_when_negated
        @failure_message_when_negated ||
          %Q(expected "#{@target}.call" not to be invoked)
      end

      def self.included(base)
        private :matches_for?, :find_actual
      end
    end
  end
end
