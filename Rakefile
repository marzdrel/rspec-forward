require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

# rubocop:disable Security/Eval
def gemspec
  @_gemspec ||= eval(File.read("rspec-forward.gemspec"), binding, ".gemspec")
end
# rubocop:enable Security/Eval

desc "Validate the gemspec"
task :gemspec do
  gemspec.validate
end

desc "Build the gem"
task gem: :gemspec do
  sh "gem build #{gemspec.name}.gemspec"

  FileUtils.mkdir_p "pkg"
  FileUtils.mv "#{gemspec.name}-#{gemspec.version}.gem", "pkg"
end
