RSpec.describe RSpec::Forward::ForwardToScope do
  context "with expected classes defined" do
    before do
      class SomeClass
        # Valid, complete example
        class ExampleClass
          def self.method_name(parent, *args)
          end
        end

        def self.example(*args)
          ExampleClass.method_name(self, *args)
        end
      end
    end

    after do
      Object.send(:remove_const, "SomeClass")
    end

    context "with properly defined call", :focus do
      it "passes" do
        expect(SomeClass)
          .to forward_to_scope(:example)
          .using_method(:method_name)
          .using_class_name("SomeClass::ExampleClass")
          .using_method_args(c: 1)
          .with_parent_arg
      end
    end
  end
end
