RSpec.describe RSpec::Forward::CoreExtensions do
  using described_class

  context "with camelized string" do
    it "does nothing" do
      expect("SomeKlassName".camelize).to eq "SomeKlassName"
    end
  end

  context "with camelized string and not uppercased 1st letter" do
    it "does nothing" do
      expect("someKlassName".camelize(false)).to eq "someKlassName"
    end
  end

  context "with uppercased 1st letter" do
    it "camelizes string" do
      expect("some_klass_name".camelize).to eq "SomeKlassName"
    end
  end

  context "without uppercased 1st letter" do
    it "camelizes string" do
      expect("some_klass_name".camelize(false))
        .to eq "someKlassName"
    end
  end

  context "with empty string" do
    it "does nothing" do
      expect("".camelize).to eq ""
    end
  end
end
