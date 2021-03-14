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


Next, include matchers in your `spec/rails_helper.rb` or `spec/spec_helper.rb` in the
`RSpec.configure` block:

```ruby
RSpec.configure do |config|
  # ...
  config.include RSpec::Forward
  # ...
end
```

If you are using [Spring](https://github.com/rails/spring) for your Rails
development, make sure the daemon is restarted after the instalation step is
complete: `spring stop`.

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

If you would rather not use the old, deprecated
`should` syntax in RSpec, replace the above exaple with the following:

```ruby
describe ".call" do
  let(:object) { described_class }

  it "passes arguments to instance" do
    expect(object)
      .to forward_to_instance(:call)
      .with_2_args
  end
end
```

Possible calls to the matcher include the following:

```ruby
it { should forward_to_instance(:call).with_no_args }
it { should forward_to_instance(:call).with_1_arg }
it { should forward_to_instance(:call).with_2_args }
it { should forward_to_instance(:call).with_3_args }
# ...

it { should forward_to_instance(:call).with_named(:foo, :bar) }
it { should forward_to_instance(:call).with_1_arg_and_named(:foo) }
it { should forward_to_instance(:call).with_2_args_and_named(:foo) }
it { should forward_to_instance(:call).with_3_args_and_named(:foo, :bar) }
```

TODO: Explain `forward_to_instance_build(...)`

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run
`bundle exec rspec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/adlugopolski/rspec-forward.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RSpec::Forward project's codebases, issue
trackers, chat rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/adlugopolski/rspec-forward/blob/master/CODE_OF_CONDUCT.md).
