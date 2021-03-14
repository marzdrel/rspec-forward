module ::RSpec
  module Forward
    class ForwardToInstanceBuild
      include ForwardMethods
      include Mocks::ExampleMethods

      def initialize(expected)
        @expected = expected
        @kwargs ||= {}
        @args ||= []
      end

      def matches?(actual)
        assign_actual(actual)

        matches_for?(actual, instance)
      end
    end
  end
end
