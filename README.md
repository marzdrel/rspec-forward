# RSpec::Forward

Gem `rspec-forward` adds simple matchers to verify short hand class proxy
method forwarding when using Method Object pattern.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rspec-forward"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rspec-forward


Include matchers in your `spec/rails_helper.rb` or `spec/spec_helper.rb` in the
`RSpec.configure` block:

```ruby
RSpec.configure do |config|
  # ...
  config.include RSpec::Forward
  # ...
end
```

## Usage

Assume you have a Method Object with `#call` method defined like this:

```ruby
class Add
  def self.call(...)
    new(...).call
  end

  def initialize(addend1, addend2)
    @addend1 = addend1
    @addend2 = addend2
  end

  def call
    @addend1 + @addend2
  end
end

Add.call(3, 5) # => 8
```

Gem `rspec-forward` adds matcher `forward_to_instance` to verify if the
call using Class Methods is properly building the instance of the calss and
forwarding the method call to expected instance method.

```ruby
require "rails_helper"

RSpec.describe Add do
  describe "#call" do
    let(:service) { described_class.new(3, 5) }

    it "adds numbers" do
      expect(service.call).to eq 8
    end
  end

  describe ".call" do
    subject { described_class }

    it { should forward_to_instance(:call).with_2_args }
  end
end
```

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and
then run `bundle exec rake release`, which will create a git tag for
the version, push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/adlugopolski/rspec-forward.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RSpec::Forward project's codebases, issue
trackers, chat rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/adlugopolski/rspec-forward/blob/master/CODE_OF_CONDUCT.md).
