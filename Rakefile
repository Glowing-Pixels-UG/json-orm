require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/test_*.rb']
  t.verbose = true
  t.warning = true
  t.ruby_opts = ['-I"test"', '-r./test/helper']
end

# Set the default task to :test if you want `rake` to run tests by default
task default: :test

desc "Tag the current version and push tags to remote"
task :tag do
  version = File.read(File.join(File.dirname(__FILE__), 'lib', 'json-orm', 'version.rb')).match(/VERSION = ['"](.*)['"]/)[1]
  `git tag -a v#{version} -m "Release version #{version}"`
  `git push origin v#{version}`
end
