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

      def description
        <<~TXT.gsub(/\n+/, " ")
          to pass the arguments to the constructor of instance, execute
          provided instance method and return the instance of the class
        TXT
      end
    end
  end
end
