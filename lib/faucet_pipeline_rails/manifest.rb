require "singleton"

module FaucetPipelineRails
  class Manifest
    include Singleton

    def fetch(asset_name)
      manifest.fetch(asset_name)
    rescue KeyError
      raise "The asset '#{asset_name}' was not in the manifest"
    end

    private

    def manifest
      return parsed_manifest unless Rails.env.production?
      @manifest ||= parsed_manifest
    end

    def parsed_manifest
      JSON.parse(unparsed_manifest)
    rescue JSON::ParserError
      raise "The manifest file '#{manifest_path}' is invalid JSON"
    end

    def unparsed_manifest
      File.read(manifest_path)
    rescue Errno::ENOENT
      raise "The manifest file '#{manifest_path}' is missing"
    end

    def manifest_path
      Rails.configuration.faucet_pipeline.manifest_path
    end
  end
end
