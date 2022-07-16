module ::RSpec
  module Forward
    module ForwardMethods
      0.upto(10) do |index|
        define_method format("with_%<count>d_args", count: index) do
          @kwargs = {}
          @args = Array.new(index, :arg)
          self
        end

        name = format("with_%<count>d_args_and_named", count: index)

        define_method name do |*kwargs|
          @args = Array.new(index, :arg)
          @kwargs = Hash[kwargs.map { |name| [name, name] }]

          self
        end
      end

      def with_1_arg
        with_1_args
      end

      def with_1_arg_and_named(*args, **kwargs)
        if kwargs.empty?
          with_1_args_and_named(*args)
        else
          with_1_args_and_named(*args, **kwargs)
        end
      end

      def with_no_args
        with_0_args
      end

      def with(*args, **kwargs)
        @args = args
        @kwargs = kwargs
        self
      end

      def with_named(*kwargs)
        @args = []
        @kwargs = Hash[kwargs.map { |name| [name, name] }]
        self
      end

      def failure_message
        "expected #{@target.inspect} to be #{@expected}"
      end

      def failure_message_when_negated
        "expected #{@target.inspect} not to be #{@expected}"
      end

      def exp_args
        if @args.size.zero? && @kwargs.size.zero?
          [no_args]
        else
          @args
        end
      end

      def instance
        @_instance ||= instance_double(@actual, @expected => :return)
      end

      def assign_actual(actual)
        @actual ||=
          if actual.is_a?(Class)
            actual
          else
            actual.class
          end
      end

      def matches_for?(actual, return_value)
        assign_actual(actual)

        if @kwargs.any?
          allow(@actual)
            .to receive(:new)
            .with(*exp_args, **@kwargs)
            .and_return(instance)

          result = @actual.send(@expected, *@args, **@kwargs) == return_value

          expect(@actual)
            .to have_received(:new)
            .with(*exp_args, **@kwargs)
        else
          allow(@actual)
            .to receive(:new)
            .with(*exp_args)
            .and_return(instance)

          result = @actual.send(@expected, *@args) == return_value

          expect(@actual)
            .to have_received(:new)
            .with(*exp_args)
        end

        result
      end

      def self.included(base)
        private :exp_args, :instance, :assign_actual, :matches_for?
      end
    end
  end
end
