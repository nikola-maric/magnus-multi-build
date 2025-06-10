require_relative "magnus_multi_build/version"
if ENV["INTEGRATE_SNOW_DUCK"] == "true"
  puts "************* INTEGRATE_SNOW_DUCK = true"
  require_relative 'magnus_multi_build/magnus_multi_build'
else
  puts "************* INTEGRATE_SNOW_DUCK = false"
  require_relative 'magnus_multi_build/magnus_multi_build_stub'
end

module MagnusMultiBuild
  class Error < StandardError; end
end