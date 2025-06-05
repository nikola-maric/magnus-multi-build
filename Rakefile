# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "rb_sys/extensiontask"

GEMSPEC = Gem::Specification.load("magnus_multi_build.gemspec") || abort('Could not load magnus_multi_build.gemspec')

Rake::ExtensionTask.new("magnus_multi_build", GEMSPEC) do |ext|
  ext.lib_dir = "lib/magnus_multi_build"
  ext.cross_compile = true
  ext.cross_platform = %w[x86_64-linux aarch64-linux]
end