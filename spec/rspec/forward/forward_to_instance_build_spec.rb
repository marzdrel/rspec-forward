RSpec.describe RSpec::Forward::ForwardToInstanceBuild do
  context "with no args" do
    let(:object) do
      Class.new do
        def self.call(*args)
          instance = new(*args)
          instance.call
          instance
        end

        def initialize
        end

        def call
        end
      end
    end

    context "with expected calls" do
      it "passes" do
        expect(object).to forward_to_instance_build(:call).with_no_args
      end
    end

    context "when expecting 1 argument" do
      let(:expectation) do
        proc do
          expect(object)
            .to forward_to_instance_build(:call)
            .with_1_args
        end
      end

      it "fails" do
        expect { expectation.call }
          .to raise_error(
            RSpec::Mocks::MockExpectationError
          )
      end
    end

    context "when expecting 2 arguments" do
      let(:expectation) do
        proc do
          expect(object)
            .to forward_to_instance_build(:call)
            .with_2_args
        end
      end

      it "fails" do
        expect { expectation.call }
          .to raise_error(
            RSpec::Mocks::MockExpectationError
          )
      end
    end

    context "with calling a private method from mixing" do
      let(:expectation) do
        proc do
          expect(object)
            .to forward_to_instance_build(:call)
            .with_no_args
            .exp_args
        end
      end

      it "raises an error" do
        expect { expectation.call }
          .to raise_error NoMethodError, /private/
      end
    end
  end

  context "with class accepting one argument" do
    let(:object) do
      Class.new do
        def self.call(*args)
          instance = new(*args)
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

    context "with matching expecations" do
      it "forwards to instance" do
        expect(object).to forward_to_instance_build(:call).with_1_arg
      end
    end

    context "with no args" do
      let(:expectation) do
        proc do
          expect(object)
            .to forward_to_instance_build(:call)
            .with_no_args
        end
      end

      it "fails" do
        expect { expectation.call }
          .to raise_error(
            RSpec::Mocks::MockExpectationError
          )
      end
    end

    context "with too many args" do
      let(:expectation) do
        proc do
          expect(object)
            .to forward_to_instance_build(:call)
            .with_3_args
        end
      end

      it "fails" do
        expect { expectation.call }
          .to raise_error(
            RSpec::Mocks::MockExpectationError,
            "Wrong number of arguments. Expected 1, got 3."
          )
      end
    end
  end

  context "with named args" do
    let(:object) do
      Class.new do
        def self.call(*args, **kwargs)
          instance = new(*args, **kwargs)
          instance.call
          instance
        end

        def initialize(model:)
          @model = model
        end

        def call
        end
      end
    end

    context "with expected amount of args" do
      it "passes" do
        expect(object)
          .to forward_to_instance_build(:call)
          .with_named(:model)
      end
    end
  end
end
