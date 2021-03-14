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

      def description
        <<~TXT.gsub(/\n+/, " ")
          to pass the arguments to the constructor of instance and return
          the value returned by the instance method
        TXT
      end
    end
  end
end
