module ::RSpec
  module Forward
    class ForwardToScope
      using CoreExtensions
      include Mocks::ExampleMethods
      include Core::Metadata

      def initialize(expected)
        @expected = expected
        @kwargs ||= {}
        @args ||= []
        @target_method_name ||= :call
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

      def using_method(target_method_name)
        @target_method_name = target_method_name
        self
      end

      private

      def matches_for?(actual, return_value)
        method_name = @expected
        base_klass = format("%<method>s_scope", method: method_name.to_s).camelize
        scope_klass_name = format("%s::%s", actual.to_s, base_klass)

        begin
          @scope_klass = Object.const_get(scope_klass_name)
        rescue NameError => e
          failure_scope_klass_name_not_defined(scope_klass_name)
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
    end
  end
end

__END__

RSpec::Matchers.define :forward_to_scope do |e_method, *args|
  match do |actual|
    e_klass = format("%s_scope",e_method.to_s).camelize
    scope_klass = format("%s::%s", described_class.to_s, e_klass).constantize
    allow(scope_klass).to receive(:call).and_return(:result)
    # actual.send(e_method, *args) == :return
    actual.send(e_method, *args)
    expect(scope_klass).to have_received(:call)
  end
end

RSpec::Matchers.define :forward_to_custom_scope do |e_method, e_klass, *args|
  match do |actual|
    scope_klass = format("%s::%s", described_class.to_s, e_klass).constantize
    allow(scope_klass).to receive(:call).and_return(:result)
    # actual.send(e_method, *args) == :return
    actual.send(e_method, *args)
    expect(scope_klass).to have_received(:call)
  end
end

RSpec::Matchers.define :forward_with_parent do |e_method, *args|
  match do |actual|
    scope_klass = format("%s_scope", e_method.to_s).camelize.constantize
    allow(scope_klass).to receive(:call).and_return(:result)
    # actual.send(e_method, *args) == :return
    actual.send(e_method, *args)
    expect(scope_klass).to have_received(:call)
  end
end

RSpec::Matchers.define :forward_custom_with_parent do |e_method, e_klass, *args|
  match do |actual|
    allow(e_klass).to receive(:call).and_return(:result)
    # actual.send(e_method, *args) == :return
    actual.send(e_method, *args)
    expect(e_klass).to have_received(:call)
  end
end
