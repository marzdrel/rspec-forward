RSpec.describe RSpec::Forward::ForwardToScope do
  context "with expected classes defeind" do
    before do
      class SomeClass
        # Valid, complete example
        class ExampleScope
          def self.call(*args)
          end
        end

        def self.example(*args)
          ExampleScope.call(*args)
        end

        # Valid, example with custom target method name
        class ExampleCustomNameScope
          def self.some_method(*args)
          end
        end

        def self.example_custom_name(*args)
          ExampleCustomNameScope.some_method(*args)
        end

        # Invalid example, missing call in the method
        class ExampleWithoutCallScope
          def self.call(*args)
          end
        end

        def self.example_without_call
        end

        # Invalid example, no method present in parent class
        class ExampleWithoutMethodScope
        end

        def self.method_with_different_name(*args)
          ExampleScope.call(*args)
        end
      end
    end

    after do
      Object.send(:remove_const, "SomeClass")
    end

    context "with expected call" do
      it "passes" do
        expect(SomeClass).to forward_to_scope(:example)
      end
    end

    context "with missing parent class" do
      it "fails with expected error" do
        expect do
          expect(SomeClass)
            .to forward_to_scope(:other)
        end
          .to raise_error(
            RSpec::Expectations::ExpectationNotMetError,
            "SomeClass::OtherScope should be defined",
          )
      end
    end

    context "with missing method in scope class" do
      it "fails with expected error" do
        expect do
          expect(SomeClass)
            .to forward_to_scope(:example_without_method)
        end
          .to raise_error(
            RSpec::Mocks::MockExpectationError,
            "SomeClass::ExampleWithoutMethodScope does not implement: call",
          )
      end
    end

    context "with missing method in scope class" do
      it "fails with expected error" do
        expect do
          expect(SomeClass)
            .to forward_to_scope(:example_without_method)
        end
          .to raise_error(
            RSpec::Mocks::MockExpectationError,
            "SomeClass::ExampleWithoutMethodScope does not implement: call",
          )
      end
    end

    context "with missing method call in base class" do
      it "fails with expected error" do
        expect do
          expect(SomeClass)
            .to forward_to_scope(:example_without_call)
        end
          .to raise_error(RSpec::Mocks::MockExpectationError)
      end
    end

    context "with custom target method name" do
      it "passes" do
        expect(SomeClass)
          .to forward_to_scope(:example_custom_name)
          .using_method(:some_method)
      end
    end

    context "with custom target method without using_method" do
      it "fails" do
        expect do
          expect(SomeClass)
            .to forward_to_scope(:example_custom_name)
        end
          .to raise_error(
            RSpec::Mocks::MockExpectationError,
            "SomeClass::ExampleCustomNameScope does not implement: call",
          )
      end
    end

    context "with custom target klass name" do
      it "passes" do
        expect(SomeClass)
          .to forward_to_scope(:method_with_different_name)
          .using_class_name("SomeClass::ExampleScope")
      end
    end

    context "with custom target klass name missing chain" do
      it "fails" do
        expect do
          expect(SomeClass)
            .to forward_to_scope(:method_with_different_name)
        end
          .to raise_error(
            RSpec::Expectations::ExpectationNotMetError,
            "SomeClass::MethodWithDifferentNameScope should be defined",
          )
      end
    end
  end
end
