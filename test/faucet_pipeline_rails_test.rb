require "test_helper"
require "fileutils"

class FaucetPipelineRails::Test < ActionDispatch::IntegrationTest
  def test_that_the_source_of_an_image_is_set_correctly
    use_assets_fixtures "good_assets"
    get "/fancy/index"
    image_src = css_select("img")[0]["src"]

    assert_equal "/assets/images/magic-f67894a08006a2af9f5076180676323c.gif", image_src
  end

  def test_that_the_href_of_a_stylesheet_is_set_correctly
    use_assets_fixtures "good_assets"
    get "/fancy/index"
    style_src = css_select("link")[0]["href"]

    assert_equal "/assets/stylesheets/application-12fcfd0548a6a948c16661f06d20046f.css", style_src
  end

  def test_that_the_src_of_a_script_tag_is_set_correctly
    use_assets_fixtures "good_assets"
    get "/fancy/index"
    script_src = css_select("script")[0]["src"]

    assert_equal "/assets/javascripts/application-c311afba193992d26b32.js", script_src
  end

  def test_raises_an_error_when_an_asset_is_not_in_the_manifest
    use_assets_fixtures "good_assets"
    err = assert_raises(ActionView::Template::Error) do
      get "/broken/index"
    end

    assert_equal err.message, "The asset 'missing.gif' was not in the manifest", "Check for descriptive error message"
  end

  def test_raises_an_error_when_manifest_is_missing
    use_assets_fixtures "assets_with_missing_manifest"

    err = assert_raises(ActionView::Template::Error) do
      get "/fancy/index"
    end

    assert_match %r{The manifest file '.+/public/assets/manifest.json' is missing}, err.message, "Check for descriptive error message"
  end

  def test_raises_an_error_when_manifest_is_invalid_json
    use_assets_fixtures "assets_with_invalid_json"

    err = assert_raises(ActionView::Template::Error) do
      get "/fancy/index"
    end

    assert_match %r{The manifest file '.+/public/assets/manifest.json' is invalid JSON}, err.message, "Check for descriptive error message"
  end

  def teardown
    FileUtils.remove_dir "test/dummy/public/assets", true
    FileUtils.remove_dir "test/dummy/public/myassets", true
  end

  private

  def use_assets_fixtures(name, asset_path: "test/dummy/public/assets")
    FileUtils.cp_r "test/fixtures/#{name}", asset_path
  end
end
