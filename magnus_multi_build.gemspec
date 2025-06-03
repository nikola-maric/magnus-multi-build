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

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions = ["ext/magnus_multi_build/extconf.rb"]

  spec.add_dependency "rb_sys", "0.9.102"
  
  spec.add_development_dependency "rake", "13.0.6"
  spec.add_development_dependency "rake-compiler", "1.2.7"
  spec.add_development_dependency "minitest", "~> 5.0"
end