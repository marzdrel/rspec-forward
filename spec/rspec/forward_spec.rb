RSpec.describe RSpec::Forward do
  describe "VERSION" do
    it "has a version number" do
      expect(RSpec::Forward::VERSION).not_to be nil
    end
  end
end
