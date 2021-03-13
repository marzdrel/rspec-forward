module ::RSpec
  module Forward
    class ForwardToInstance
      include ::RSpec::Mocks::ExampleMethods

      def initialize(expected)
        @expected = expected
        @kwargs ||= {}
        @args ||= []
      end

      def matches?(actual)
        @actual = actual

        actual = actual.class unless actual.is_a?(Class)

        instance = instance_double(actual, @expected => :return)

        allow(actual)
          .to receive(:new)
          .with(*exp_args, **@kwargs)
          .and_return(instance)

        actual.send(@expected, *@args, **@kwargs) == :return
      end

      0.upto(10) do |index|
        define_method format("with_%<count>d_args", count: index) do
          @args = Array.new(index, :arg)
          self
        end
      end

      def with_1_arg
        with_1_args
      end

      def with_no_args
        with_0_args
      end

      def with(*args, **kwargs)
        @args = args
        @kwargs = kwargs
        self
      end

      def with_named(**kwargs)
        @args = []
        @kwargs = kwargs
        self
      end

      def failure_message
        "expected #{@target.inspect} to be #{@expected}"
      end

      def failure_message_when_negated
        "expected #{@target.inspect} not to be #{@expected}"
      end

      private

      def exp_args
        if @args.size.zero? && @kwargs.size.zero?
          [no_args]
        else
          @args
        end
      end
    end

    def forward_to_instance(expected)
      ForwardToInstance.new(expected)
    end
  end
end
