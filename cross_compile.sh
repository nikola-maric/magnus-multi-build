#!/bin/bash

set -euo pipefail

# Configuration
LIB_DIR="lib/magnus_multi_build"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
}

# Function to cross-compile for a specific architecture
cross_compile_arch() {
    local arch=$1
    log "Starting cross-compilation for $arch"

    # Clean up any existing build artifacts
    rm -rf tmp/
    
    # Run rb-sys-dock with the command inside the container
    log "Running rb-sys-dock container for $arch with custom command"
    bundle exec rb-sys-dock --platform "$arch" -- bash -c "bundle install && bundle exec rake compile native:magnus_multi_build:$arch"
}

# Main execution
main() {
    # Check if specific architecture was passed as argument
    if [[ $# -eq 0 ]]; then
        error "Usage: $0 <architecture>"
        error "Example: $0 x86_64-linux"
        exit 1
    fi
    
    local target_arch=$1
    log "Building for architecture: $target_arch"
    
    # Ensure we're in the right directory
    if [[ ! -f "magnus_multi_build.gemspec" ]]; then
        error "Please run this script from the gem root directory"
        exit 1
    fi
    
    # Create base lib directory if it doesn't exist
    mkdir -p "$LIB_DIR"
    
    # Build for specified architecture
    if cross_compile_arch "$target_arch"; then
        log "✅ Successfully built for: $target_arch"
    else
        error "❌ Failed to build for: $target_arch"
        exit 1
    fi
}

# Run main function
main "$@"