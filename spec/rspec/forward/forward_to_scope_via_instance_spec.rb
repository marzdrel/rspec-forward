RSpec.describe RSpec::Forward::ForwardToScope do
  context "with expected classes defined" do
    before do
      class SomeClass
        # Valid, complete example
        class ExampleScope
          def self.call(*args)
          end
        end

        def example(*args)
          ExampleScope.call(*args)
        end

        def example_kwargs(data:)
          ExampleScope.call(data: data)
        end
      end
    end

    after do
      Object.send(:remove_const, "SomeClass")
    end

    context "with expected call" do
      it "passes" do
        expect(SomeClass.new).to forward_to_scope(:example)
      end
    end

    context "with expected call and kwargs" do
      it "passes" do
        expect(SomeClass.new)
          .to forward_to_scope(:example_kwargs)
          .using_class_name("SomeClass::ExampleScope")
          .using_method_args(data: "value")
      end
    end
  end
end
