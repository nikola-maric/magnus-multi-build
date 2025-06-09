# Magnus Multi Build

A Ruby gem demonstrating cross-platform native extension building using the [Magnus](https://github.com/matsadler/magnus) crate and [rb-sys-dock](https://github.com/oxidize-rb/rb-sys/tree/main/crates/rb-sys-dock) for containerized cross-compilation.

## Overview

This project showcases how to build a Ruby gem with Rust native extensions that can be compiled for multiple architectures (x86_64-linux and aarch64-linux) using Magnus, a Ruby binding library for Rust.

### Magnus Integration

Magnus provides a high-level, safe interface for writing Ruby extensions in Rust. In this project:

- **Rust Code**: Located in `ext/magnus_multi_build/src/lib.rs`, implements a simple string reversal function
- **Ruby Interface**: The Rust function is exposed as `RustStringUtils.reverse` in Ruby
- **Safe Bindings**: Magnus handles all the Ruby C API interactions safely

Example usage:
```ruby
require 'magnus_multi_build'
RustStringUtils.reverse("hello") # => "olleh"
```

## Cross-Platform Building

### The `cross_compile.sh` Script

The main build orchestrator is the `cross_compile.sh` script, which:

1. **Defines Target Architectures**: Currently supports `x86_64-linux` and `aarch64-linux`
2. **Uses rb-sys-dock**: Runs containerized cross-compilation for each architecture
3. **Organizes Binaries**: Stores compiled `.so` files in architecture-specific directories:
   - `lib/magnus_multi_build/x86_64-linux/magnus_multi_build.so`
   - `lib/magnus_multi_build/aarch64-linux/magnus_multi_build.so`
4. **Provides Feedback**: Colored logging and comprehensive error reporting

### What the Script Does

For each target architecture, the script:
1. Launches a `rb-sys-dock` container for the specific platform
2. Runs `bundle install && bundle exec rake compile native:{arch}` inside the container
3. Copies the resulting `.so` file to an architecture-specific directory
4. Validates successful compilation

## rb-sys-dock

[rb-sys-dock](https://github.com/oxidize-rb/rb-sys/tree/main/crates/rb-sys-dock) is a containerized cross-compilation environment that:

- **Provides Consistent Build Environment**: Docker containers with pre-configured toolchains
- **Supports Multiple Architectures**: x86_64 and aarch64 Linux targets
- **Handles Complex Dependencies**: Ruby headers, system libraries, and cross-compilation toolchains
- **Integrates with rb-sys**: Works seamlessly with the rb-sys build system

In this project, we use it via:
```bash
bundle exec rb-sys-dock --platform "$arch" -- bash -c "bundle install && bundle exec rake compile native:$arch"
```

## Gemspec Configuration

### Commented Extensions Section

The `extensions` configuration in `magnus_multi_build.gemspec:30` is commented out:

```ruby
# spec.extensions = ['ext/magnus_multi_build/extconf.rb']
```

**Why?** Because we're using a custom build process instead of the standard RubyGems native extension workflow:

1. **Custom Build Process**: We use `cross_compile.sh` to build binaries for multiple architectures
2. **Pre-built Binaries**: The gem ships with pre-compiled `.so` files in architecture-specific directories
3. **Runtime Selection**: The gem dynamically loads the correct binary based on the `MAGNUS_TARGET_ARCH` environment variable
4. **Avoid Build Errors**: Without commenting this out, users would see: `"Ignoring magnus_multi_build-0.1.0 because its extensions are not built"`

### Runtime Architecture Selection

The gem uses a custom loading mechanism in `lib/magnus_multi_build.rb:8-33`:

- Reads `MAGNUS_TARGET_ARCH` environment variable
- Validates against supported architectures
- Loads the appropriate `.so` file from the architecture-specific directory
- Provides clear error messages for missing or invalid configurations

## Usage

1. **Build for all architectures**:
   ```bash
   ./cross_compile.sh
   ```

2. **Set target architecture and use**:
   ```bash
   export MAGNUS_TARGET_ARCH=x86_64-linux
   ruby -r magnus_multi_build -e "puts RustStringUtils.reverse('Hello World')"
   ```

## Dependencies

- **rb_sys**: Ruby-Rust integration and build system
- **magnus**: High-level Ruby bindings for Rust
- **Docker**: Required for rb-sys-dock cross-compilation

## Architecture Support

Currently supports:
- `x86_64-linux` (Intel/AMD 64-bit Linux)
- `aarch64-linux` (ARM 64-bit Linux)

Additional architectures can be added by updating the `ARCHITECTURES` array in `cross_compile.sh`.