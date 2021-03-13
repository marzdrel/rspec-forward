RSpec.describe RSpec::Forward do
  describe "VERSION" do
    it "has a version number" do
      expect(RSpec::Forward::VERSION).not_to be nil
    end
  end

  context "with 0-arg class" do
    before do
      class TestClass
        def self.call(...)
          new(...).call
        end

        def initialize; end
        def call; end
      end
    end

    after { Object.send(:remove_const, "TestClass") }

    let(:object) { TestClass }

    it "forwards to instance" do
      expect(object).to forward_to_instance(:call).with_no_args
    end

    it "fails to forward with arg" do
      expect { expect(object).to forward_to_instance(:call).with_1_arg }
        .to raise_error RSpec::Mocks::MockExpectationError
    end

    it "fails to forward with too many args" do
      expect { expect(object).to forward_to_instance(:call).with_2_args }
        .to raise_error RSpec::Mocks::MockExpectationError
    end
  end

  context "with 1-arg class" do
    before do
      class TestClass
        def self.call(...)
          new(...).call
        end

        def initialize(arg)
          @arg = arg
        end

        def call
        end
      end
    end

    after { Object.send(:remove_const, "TestClass") }

    let(:object) { TestClass }

    it "forwards to instance" do
      expect(object).to forward_to_instance(:call).with_1_arg
    end

    it "fails to forward wihout args " do
      expect { expect(object).to forward_to_instance(:call).with_no_args }
        .to raise_error RSpec::Mocks::MockExpectationError
    end

    it "fails to forward with too many args" do
      expect { expect(object).to forward_to_instance(:call).with_3_args }
        .to raise_error RSpec::Mocks::MockExpectationError
    end
  end
end
