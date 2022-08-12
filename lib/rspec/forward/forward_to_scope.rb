module ::RSpec
  module Forward
    class ForwardToScope
      include ForwardScopeMethods
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
