require "faucet_pipeline_rails/manifest"

module FaucetPipelineRails
  module ComputeAssetPath
    TYPES_WITH_MANIFEST = %i(stylesheet image javascript)

    def compute_asset_path(source, options = {})
      if TYPES_WITH_MANIFEST.include? options[:type]
        manifest = Manifest.new(manifests_path, options[:type])
        manifest.fetch(source)
      else
        source
      end
    end

    def manifests_path
      Rails.configuration.x.faucet_pipeline.manifests_path ||
        File.join("public", "assets", "manifests")
    end
  end
end
