require "faucet_pipeline_rails/manifest"

module FaucetPipelineRails
  module ComputeAssetPath
    MANIFEST_FOR_TYPE = {
      image: "static",
      stylesheet: "stylesheet",
      javascript: "javascript"
    }

    def compute_asset_path(source, options = {})
      if MANIFEST_FOR_TYPE.has_key? options[:type]
        manifest = Manifest.new(manifests_path, MANIFEST_FOR_TYPE[options[:type]])
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
