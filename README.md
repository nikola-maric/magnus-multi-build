# MagnusMultiBuild

A Ruby gem that demonstrates cross-platform native extensions using Rust and the Magnus crate. This gem provides string manipulation utilities and DuckDB database functionality through compiled Rust code, supporting multiple Linux architectures.

## Overview

MagnusMultiBuild showcases how to build and distribute Ruby gems with native extensions that support multiple target architectures. The gem includes:

- **String utilities**: Reverse string functionality implemented in Rust
- **Database operations**: DuckDB query execution through Rust bindings
- **Cross-platform support**: Pre-compiled binaries for x86_64-linux and aarch64-linux
- **Architecture-aware loading**: Dynamic selection of the appropriate binary at runtime

## Architecture Support

The gem supports the following architectures:
- `x86_64-linux` - Intel/AMD 64-bit Linux
- `aarch64-linux` - ARM 64-bit Linux (including Apple Silicon via emulation)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'magnus_multi_build'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install magnus_multi_build
```

## Usage

Before using the gem, you must set the target architecture:

```bash
export MAGNUS_TARGET_ARCH=x86_64-linux
# or
export MAGNUS_TARGET_ARCH=aarch64-linux
```

Then use the gem in your Ruby code:

```ruby
require 'magnus_multi_build'

# String manipulation
puts RustStringUtils.reverse("Hello World!")  # => "!dlroW olleH"

# DuckDB queries
result = RustStringUtils.duckdb_query("test query")
puts result  # => "test query"
```

## Cross-Compilation Process

### Tools and Technologies

This gem uses several key technologies for cross-compilation:

1. **[Magnus](https://github.com/matsadler/magnus)** - Rust crate for creating Ruby extensions
2. **[rb-sys](https://github.com/oxidize-rb/rb-sys)** - Ruby to Rust build system integration
3. **[rb-sys-dock](https://github.com/oxidize-rb/rb-sys-dock)** - Containerized cross-compilation environment
4. **[DuckDB](https://duckdb.org/)** - Embedded analytical database
5. **GitHub Actions** - Automated cross-compilation workflow

### Build Configuration

#### Rakefile (`Rakefile`)

```ruby
require "rb_sys/extensiontask"

Rake::ExtensionTask.new("magnus_multi_build", GEMSPEC) do |ext|
  ext.lib_dir = "lib/magnus_multi_build"
  ext.cross_compile = true
  ext.cross_platform = %w[x86_64-linux aarch64-linux]
end
```

#### Extension Configuration (`ext/magnus_multi_build/extconf.rb`)

```ruby
require "mkmf"
require "rb_sys/mkmf"

create_rust_makefile("magnus_multi_build") do |r|
  r.profile = :release
end
```

### Automated Cross-Compilation Workflow

The gem uses GitHub Actions for automated cross-compilation (`.github/workflows/cross-compile.yml`):

#### Workflow Features

- **Matrix builds**: Parallel compilation for multiple architectures
- **Containerized environment**: Uses `rb-sys-dock` for consistent build environments
- **Artifact management**: Automatic collection and organization of compiled binaries
- **Pull request automation**: Creates PRs with new binaries

#### Compilation Command

```bash
RUBY_CC_VERSION=2.7.8 bundle exec rb-sys-dock --platform ${{ matrix.architecture }} -- bash -c \
"bundle install && bundle exec rake native:magnus_multi_build:${{ matrix.architecture }} && mv -f tmp/${{ matrix.architecture }}/stage/lib/magnus_multi_build/magnus_multi_build.so lib/magnus_multi_build/${{ matrix.architecture }}/magnus_multi_build.so"
```

### Manual Cross-Compilation

To manually cross-compile for a specific architecture:

```bash
# Set up environment
bundle install

# Cross-compile for x86_64-linux
RUBY_CC_VERSION=2.7.8 bundle exec rb-sys-dock --platform x86_64-linux -- bash -c \
  "bundle install && bundle exec rake native:magnus_multi_build:x86_64-linux"

# Cross-compile for aarch64-linux
RUBY_CC_VERSION=2.7.8 bundle exec rb-sys-dock --platform aarch64-linux -- bash -c \
  "bundle install && bundle exec rake native:magnus_multi_build:aarch64-linux"
```

### Docker Development Environment

Use Docker Compose for development:

```bash
# Build and run container
TARGET_ARCH=x86_64-linux docker-compose up --build magnus-gem

# Interactive development
docker-compose run --rm magnus-gem bash
```

## Architecture Detection and Loading

The gem implements intelligent architecture detection (`lib/magnus_multi_build.rb`):

```ruby
def self.load_native_extension
  target_arch = ENV['MAGNUS_TARGET_ARCH']
  
  # Validation
  unless SUPPORTED_ARCHITECTURES.include?(target_arch)
    raise Error, "Unsupported target architecture: #{target_arch}"
  end
  
  # Load architecture-specific extension
  arch_specific_path = File.expand_path("magnus_multi_build/#{target_arch}/magnus_multi_build", __dir__)
  require arch_specific_path
end
```

## Rust Implementation

The core functionality is implemented in Rust (`ext/magnus_multi_build/src/lib.rs`):

### Dependencies

- `magnus` - Ruby-Rust FFI bindings
- `duckdb` - Embedded database functionality

### Functions

```rust
// String reversal utility
fn reverse_string(input: String) -> String {
    input.chars().rev().collect()
}

// DuckDB query execution
fn duckdb_query(query: String) -> Result<String, Error> {
    let conn = Connection::open_in_memory()?;
    // Query execution logic...
}

// Ruby class definition
#[magnus::init]
fn init(ruby: &Ruby) -> Result<(), Error> {
    let class = ruby.define_class("RustStringUtils", ruby.class_object())?;
    class.define_singleton_method("reverse", function!(reverse_string, 1))?;
    class.define_singleton_method("duckdb_query", function!(duckdb_query, 1))?;
    Ok(())
}
```

## Testing Cross-Compiled Binaries

Test the compiled binaries:

```bash
# Test x86_64-linux binary
export MAGNUS_TARGET_ARCH=x86_64-linux
ruby -r magnus_multi_build -e "puts RustStringUtils.reverse('Hello')"

# Test aarch64-linux binary
export MAGNUS_TARGET_ARCH=aarch64-linux
ruby -r magnus_multi_build -e "puts RustStringUtils.reverse('World')"
```

## Directory Structure

```
lib/magnus_multi_build/
├── x86_64-linux/
│   └── magnus_multi_build.so    # x86_64 binary
├── aarch64-linux/
│   └── magnus_multi_build.so    # ARM64 binary
└── version.rb                   # Gem version
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.

### Development Workflow

1. Make changes to Rust code in `ext/magnus_multi_build/src/lib.rs`
2. Test locally with `bundle exec rake compile`
3. Use GitHub Actions workflow for cross-compilation
4. Test binaries with different `MAGNUS_TARGET_ARCH` values

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nikola-maric/magnus_multi_build.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).