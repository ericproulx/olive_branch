require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec
task :benchmark do
  sh 'BENCHMARK_REPETITIONS=1000 rspec spec/benchmark_spec.rb'
end
