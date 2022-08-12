RSpec.describe RSpec::Forward::ForwardToScope do
  context "with expected classes defeind" do
    before do
      class SomeClass
        class ExampleWithoutCallScope
          def self.call(*args)
          end
        end

        class ExampleWithoutMethodScope
        end

        class ExampleScope
          def self.call(*args)
          end
        end

        def self.example(*args)
          ExampleScope.call(*args)
        end

        def self.example_without_call
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
  end
end
