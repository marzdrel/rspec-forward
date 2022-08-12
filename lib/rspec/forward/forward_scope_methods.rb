module ::RSpec
  module Forward
    module ForwardScopeMethods
      using CoreExtensions

      def using_method(target_method_name)
        @target_method_name = target_method_name
        self
      end

      def using_class_name(target_class_name)
        @scope_klass_name = target_class_name
        self
      end

      def matches_for?(actual)
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

        result = actual.public_send(method_name) == :result

        expect(@scope_klass)
          .to have_received(@target_method_name)

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
        private :matches_for?
      end
    end
  end
end
