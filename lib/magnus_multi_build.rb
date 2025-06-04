require_relative "magnus_multi_build/version"

module MagnusMultiBuild
  class Error < StandardError; end
  
  SUPPORTED_ARCHITECTURES = %w[x86_64-linux aarch64-linux].freeze
  
  # Load the appropriate native extension based on architecture
  def self.load_native_extension
    # Get target architecture from environment variable
    target_arch = ENV['MAGNUS_TARGET_ARCH']
    
    # Error if not provided
    if target_arch.nil? || target_arch.empty?
      raise Error, "MAGNUS_TARGET_ARCH environment variable must be set. Supported architectures: #{SUPPORTED_ARCHITECTURES.join(', ')}"
    end
    
    # Validate the target architecture
    unless SUPPORTED_ARCHITECTURES.include?(target_arch)
      raise Error, "Unsupported target architecture: #{target_arch}. Supported architectures: #{SUPPORTED_ARCHITECTURES.join(', ')}"
    end
    
    # Load architecture-specific extension
    arch_specific_path = File.expand_path("magnus_multi_build/#{target_arch}/magnus_multi_build", __dir__)
    
    if File.exist?("#{arch_specific_path}.so") || File.exist?("#{arch_specific_path}.bundle")
      require arch_specific_path
    else
      raise Error, "Native extension not found for #{target_arch} at #{arch_specific_path}.so"
    end
  rescue LoadError => e
    raise Error, "Failed to load native extension for #{target_arch}: #{e.message}"
  end
end

# Load the extension
MagnusMultiBuild.load_native_extension