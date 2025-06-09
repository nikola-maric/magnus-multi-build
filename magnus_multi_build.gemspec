require_relative "lib/magnus_multi_build/version"

Gem::Specification.new do |spec|
  spec.name = "magnus_multi_build"
  spec.version = MagnusMultiBuild::VERSION
  spec.authors = ["Developer"]
  spec.email = ["dev@example.com"]

  spec.summary = "Multi-arch Ruby gem using Magnus and rb-sys"
  spec.description = "A playground for testing multi-architecture builds of Rust-based native gems using Magnus crate"
  spec.homepage = "https://github.com/example/magnus-multi-build"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir['lib/**/*.{rb,so}', 'ext/**/*.{rs,rb}', '**/Cargo.*', 'LICENSE.txt', 'README.md']
  spec.bindir = "exe"
  spec.executables = []
  spec.require_paths = ['lib']
  # commenting this out - we are not using standard bundler/rubygems way of building native extensions
  # We are:
  #  - running `./cross_compile` to basically run `bundle exec rb-sys-dock --platform {arch}` for us
  #  - script builds and stores .so files in separate {arch}/ directories
  #  - gem then decides which one to load based on ENV, passed on by docker build arg
  # once built, we can create PR to include it in the project
  # but because these live in their own folders and get built by this process, we don't actually use standard bundler/rubygems way of building native extensions
  # so we need to comment out this extensions part, because if we didn't we would get "Ignoring magnus_multi_build-0.1.0 because its extensions are not built. Try: gem pristine magnus_multi_build --version 0.1.0" message
  # spec.extensions = ['ext/magnus_multi_build/extconf.rb']

  spec.add_dependency "rb_sys", "0.9.116"
end