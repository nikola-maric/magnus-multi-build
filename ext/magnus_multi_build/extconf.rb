require "mkmf"
require "rb_sys/mkmf"

create_rust_makefile("magnus_multi_build") do |r|
  r.profile = :release
end