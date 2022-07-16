RSpec.describe RSpec::Forward::ForwardToInstance do
  context "with 0-arg class" do
    let(:klass) do
      Class.new do
        def self.call(*args)
          new.call(*args)
        end

        def initialize
        end

        def call
        end
      end
    end

    context "with no args as expected" do
      it "passes" do
        expect(klass).to forward_to_instance(:call).with_no_args
      end
    end

    context "with 1 arg expectation " do
      let(:expectation) do
        proc do
          expect(klass)
            .to forward_to_instance(:call)
            .with_1_arg
        end
      end

      it "fails" do
        expect { expectation.call }
          .to raise_error(
            RSpec::Mocks::MockExpectationError,
            "Wrong number of arguments. Expected 0, got 1."
          )
      end
    end

    context "with multiple args" do
      let(:expectation) do
        proc do
          expect(klass)
            .to forward_to_instance(:call)
            .with_2_args
        end
      end

      it "fails" do
        expect { expectation.call }
          .to raise_error(
            RSpec::Mocks::MockExpectationError,
            "Wrong number of arguments. Expected 0, got 2."
          )
      end
    end
  end

  context "with 1-arg class" do
    let(:klass) do
      Class.new do
        def self.call(*args)
          new(*args).call
        end

        def initialize(arg)
          @arg = arg
        end

        def call
        end

        def perform
        end
      end
    end

    context "with expected arguments" do
      it "passes" do
        expect(klass).to forward_to_instance(:call).with_1_arg
      end
    end

    context "with missing instance method name" do
      let(:expectation) do
        proc do
          expect(klass)
            .to forward_to_instance(:unknown)
            .with_1_arg
        end
      end

      it "fails" do
        expect { expectation.call }
          .to raise_error(
            RSpec::Mocks::MockExpectationError,
            /class does not implement the instance method: unknown/
          )
      end
    end

    context "with missing class method name" do
      let(:expectation) do
        proc do
          expect(klass)
            .to forward_to_instance(:perform)
            .with_1_arg
        end
      end

      it "fails" do
        expect { expectation.call }
          .to raise_error(
            NoMethodError,
            /undefined method `perform' for/
          )
      end
    end

    context "with no args" do
      let(:expectation) do
        proc do
          expect(klass)
            .to forward_to_instance(:call)
            .with_no_args
        end
      end

      it "fails" do
        expect { expectation.call }
          .to raise_error(
            RSpec::Mocks::MockExpectationError,
            "Wrong number of arguments. Expected 1, got 0."
          )
      end
    end

    context "with too many args" do
      let(:expectation) do
        proc do
          expect(klass)
            .to forward_to_instance(:call)
            .with_3_args
        end
      end

      it "fails to forward with too many args" do
        expect { expectation.call }
          .to raise_error(
            RSpec::Mocks::MockExpectationError,
            "Wrong number of arguments. Expected 1, got 3."
          )
      end
    end

    context "with invalid expectation for named args" do
      let(:expectation) do
        proc do
          expect(klass)
            .to forward_to_instance(:call)
            .with_1_arg_and_named(:age)
        end
      end

      it "fails with mismatch of args" do
        expect { expectation.call }
          .to raise_error(
            RSpec::Mocks::MockExpectationError,
            "Wrong number of arguments. Expected 1, got 2."
          )
      end
    end
  end

  context "with named args" do
    let(:klass) do
      Class.new do
        def self.call(**args)
          new(**args).call
        end

        def initialize(model:, other:)
          @model = model
          @other = other
        end

        def call
        end
      end
    end

    it "forwards to instance" do
      expect(klass)
        .to forward_to_instance(:call)
        .with_named(:model, :other)
    end
  end

  context "with mix of positional and named args" do
    let(:klass) do
      Class.new do
        def self.call(*args, **kwargs)
          new(*args, **kwargs).call
        end

        def initialize(name, age:)
          @name = name
          @age = age
        end

        def call
        end
      end
    end

    context "with expected arguments" do
      it "passes" do
        expect(klass)
          .to forward_to_instance(:call)
          .with_1_arg_and_named(:age)
      end
    end

    context "with no named arguments expected" do
      let(:expectation) do
        proc do
          expect(klass)
            .to forward_to_instance(:call)
            .with_1_arg
        end
      end

      it "fails" do
        expect { expectation.call }
          .to raise_error(
            RSpec::Mocks::MockExpectationError,
            "Missing required keyword arguments: age"
          )
      end
    end

    context "with argument name mismatch" do
      let(:expectation) do
        proc do
          expect(klass)
            .to forward_to_instance(:call)
            .with_1_arg_and_named(:height)
        end
      end

      it "fails" do
        expect { expectation.call }
          .to raise_error(
            RSpec::Mocks::MockExpectationError,
            "Missing required keyword arguments: age"
          )
      end
    end

    context "with too many named arguments" do
      let(:expectation) do
        proc do
          expect(klass)
            .to forward_to_instance(:call)
            .with_1_arg_and_named(:age, :height)
        end
      end

      it "fails" do
        expect { expectation.call }
          .to raise_error(
            RSpec::Mocks::MockExpectationError,
            "Invalid keyword arguments provided: height"
          )
      end
    end

    context "with no positional arguments" do
      let(:expectation) do
        proc do
          expect(klass)
            .to forward_to_instance(:call)
            .with_named(:age)
        end
      end

      it "fails assuming the positional arg as hash due to no_args" do
        expect { expectation.call }
          .to raise_error(
            RSpec::Mocks::MockExpectationError,
            "Missing required keyword arguments: age"
          )
      end
    end
  end
end
