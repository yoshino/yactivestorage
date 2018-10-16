require "bundler/setup"
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |test|
  test.libs << "test"
  test.libs << "app/controllers"
  test.test_files = FileList["test/**/*_test.rb"]
  test.warning = false
end

task default: :test
