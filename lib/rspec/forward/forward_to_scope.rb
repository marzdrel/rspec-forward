module ::RSpec
  module Forward
    class ForwardToScope
      include ForwardScopeMethods
      include ForwardScopeParentMethods
      include Mocks::ExampleMethods

      def initialize(expected)
        @expected = expected
        @kwargs ||= {}
        @args ||= []
        @target_method_name ||= :call
      end

      def matches?(actual)
        matches_for?(actual)
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
