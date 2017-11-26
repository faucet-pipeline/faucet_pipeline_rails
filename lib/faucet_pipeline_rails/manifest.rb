module FaucetPipelineRails
  class Manifest
    def initialize(manifest_path)
      @manifest_path = manifest_path
    end

    def fetch(asset_name)
      parsed_manifest.fetch(asset_name)
    rescue KeyError
      raise "The asset '#{asset_name}' was not in the manifest"
    end

    private

    attr_reader :manifest_path

    def parsed_manifest
      JSON.parse(unparsed_manifest)
    rescue JSON::ParserError
      raise "The manifest file '#{manifest_path}' is invalid JSON"
    end

    def unparsed_manifest
      File.read(full_manifest_path)
    rescue Errno::ENOENT
      raise "The manifest file '#{manifest_path}' is missing"
    end

    def full_manifest_path
      File.join(Rails.root, manifest_path)
    end
  end
end
