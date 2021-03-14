RSpec.describe RSpec::Forward::ForwardToInstanceBuild do
  context "with 0-arg class" do
    before do
      class TestClass
        def self.call(...)
          instance = new(...)
          instance.call
          instance
        end

        def initialize; end
        def call; end
      end
    end

    after { Object.send(:remove_const, "TestClass") }

    let(:object) { TestClass }

    it "forwards to instance" do
      expect(object).to forward_to_instance_build(:call).with_no_args
    end

    it "fails to forward with arg" do
      expect { expect(object).to forward_to_instance_build(:call).with_1_arg }
        .to raise_error RSpec::Mocks::MockExpectationError
    end

    it "fails to forward with too many args" do
      expect { expect(object).to forward_to_instance_build(:call).with_2_args }
        .to raise_error RSpec::Mocks::MockExpectationError
    end

    it "keeps the implementation private" do
      expect {
        expect(object)
          .to forward_to_instance_build(:call)
          .with_no_args
          .exp_args
      }.to raise_error NoMethodError, /private/
    end
  end

  context "with 1-arg class" do
    before do
      class TestClass
        def self.call(...)
          instance = new(...)
          instance.call
          instance
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
      expect(object).to forward_to_instance_build(:call).with_1_arg
    end

    it "fails to forward wihout args " do
      expect { expect(object).to forward_to_instance_build(:call).with_no_args }
        .to raise_error RSpec::Mocks::MockExpectationError
    end

    it "fails to forward with too many args" do
      expect { expect(object).to forward_to_instance_build(:call).with_3_args }
        .to raise_error RSpec::Mocks::MockExpectationError
    end
  end

  context "with named args" do
    before do
      class TestClass
        def self.call(...)
          instance = new(...)
          instance.call
          instance
        end

        def initialize(model:)
          @model = model
        end

        def call; end
      end
    end

    after { Object.send(:remove_const, "TestClass") }

    let(:object) { TestClass }

    it "forwards to instance" do
      expect(object)
        .to forward_to_instance_build(:call)
        .with_named(model: "name")
    end
  end
end
