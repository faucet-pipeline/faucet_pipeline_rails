require "faucet_pipeline_rails/compute_asset_path"

module FaucetPipelineRails
  class Railtie < Rails::Railtie
    ActiveSupport.on_load(:action_view) do
      include FaucetPipelineRails::ComputeAssetPath
    end
  end
end
