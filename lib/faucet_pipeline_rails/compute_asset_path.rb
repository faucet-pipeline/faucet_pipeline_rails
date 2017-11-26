require "faucet_pipeline_rails/manifest"

module FaucetPipelineRails
  module ComputeAssetPath
    def compute_asset_path(source, _)
      manifest = Manifest.new(manifests_path)
      manifest.fetch(source)
    end

    def manifests_path
      Rails.configuration.x.faucet_pipeline.manifest_path ||
        File.join("public", "assets", "manifest.json")
    end
  end
end
