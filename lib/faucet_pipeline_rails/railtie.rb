require "faucet_pipeline_rails/manifest"

module FaucetPipelineRails
  class Railtie < Rails::Railtie
    ActiveSupport.on_load(:action_view) do
      # Overwrite `compute_asset_path` with our own implementation
      define_method(:compute_asset_path) do |source, _|
        Manifest.instance.fetch(source)
      end
    end
  end
end
