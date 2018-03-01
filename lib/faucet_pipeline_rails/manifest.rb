require "singleton"

module FaucetPipelineRails
  class Manifest
    include Singleton

    def fetch(asset_name)
      parsed_manifest.fetch(asset_name)
    rescue KeyError
      raise "The asset '#{asset_name}' was not in the manifest"
    end

    private

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
      Rails.configuration.x.faucet_pipeline.manifest_path ||
        Rails.root.join("public", "assets", "manifest.json")
    end
  end
end
