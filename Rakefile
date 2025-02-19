require 'rspec/core/rake_task'

task default: %w[test]

desc 'Run all available tests'
task :test do
  RSpec::Core::RakeTask.new(:spec)
  Rake::Task['spec'].invoke
end
