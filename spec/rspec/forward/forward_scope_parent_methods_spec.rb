RSpec.describe RSpec::Forward::ForwardScopeParentMethods do
  context "with expected classes defined" do
    before do
      class SomeClass
        # Valid, complete example
        class ExampleScope
          def self.call(parent, *args)
          end
        end

        def self.example(*args)
          ExampleScope.call(self, *args)
        end
      end
    end

    after do
      Object.send(:remove_const, "SomeClass")
    end

    context "with expected call" do
      it "passes" do
        expect(SomeClass)
          .to forward_to_scope(:example)
          .with_parent_arg
      end
    end

    context "without required chain method" do
      it "fails on invalid args", :no_truncate do
        expect { expect(SomeClass).to forward_to_scope(:example) }
          .to raise_error(
            RSpec::Mocks::MockExpectationError,
            /received :call with unexpected arguments/
          )
      end
    end
  end
end
