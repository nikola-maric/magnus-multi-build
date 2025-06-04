# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "rb_sys/extensiontask"

GEMSPEC = Gem::Specification.load("magnus_multi_build.gemspec") || abort('Could not load magnus_multi_build.gemspec')

Rake::ExtensionTask.new("magnus_multi_build", GEMSPEC) do |ext|
  ext.lib_dir = "lib/magnus_multi_build"
end

task :fmt do
  sh 'cargo', 'fmt'
end

desc "Build native extension for a given platform (i.e. `rake 'native[x86_64-linux]'`)"
task :native, [:platform] do |_t, platform:|
  sh 'bundle', 'exec', 'rb-sys-dock', '--platform', platform, '--build'
end

task :cargo_test do
  sh 'cargo test'
end

task test: %i[ruby_test cargo_test]

task build: :compile

task default: %i[compile test]