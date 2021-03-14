# A sample Guardfile
# More info at https://github.com/guard/guard#readme

GUARD_OPTIONS = {
  failed_mode: :keep,
  cmd: "rspec --order rand:$RANDOM",
  title: "RSpec"
}.freeze

guard :rspec, GUARD_OPTIONS do
  directories %w[spec lib]

  watch(%r{^spec/.+_spec\.rb$})

  watch(%r{^lib/(.+)\.rb$}) do |m|
    "spec/#{m[1]}_spec.rb"
  end

  watch("spec/spec_helper.rb") do
    "spec"
  end

  watch(%r{^spec/support/(.+)\.rb$}) do
    "spec"
  end
end
