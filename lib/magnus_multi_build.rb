require_relative "magnus_multi_build/version"

begin
  ruby_version = RUBY_VERSION.to_f
  RUBY_VERSION =~ /(\d+\.\d+)/
  require_relative "magnus_multi_build/#{$1}/magnus_multi_build"
rescue LoadError
  require_relative "magnus_multi_build/magnus_multi_build"
end

module MagnusMultiBuild
  class Error < StandardError; end
end