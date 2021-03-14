module ::RSpec
  module Forward
    class ForwardToInstance
      include ForwardMethods
      include Mocks::ExampleMethods

      def initialize(expected)
        @expected = expected
        @kwargs ||= {}
        @args ||= []
      end

      def matches?(actual)
        matches_for?(actual, :return)
      end
    end
  end
end
