# Use Rails with faucet-pipeline [![Build Status](https://travis-ci.org/faucet-pipeline/faucet_pipeline_rails.svg)](https://travis-ci.org/faucet-pipeline/faucet_pipeline_rails)

Instead of using the built-in asset pipeline of Rails, use
[`faucet-pipeline`](https://github.com/faucet-pipeline/faucet-pipeline). This
gem enables the required integration with Rails.

[You can find an example app
here](https://github.com/faucet-pipeline/faucet_pipeline_rails_example).

Why is an integration like that required? `faucet-pipeline` modifies the names
of the generated files depending on their content (by adding a hash of the file
to the name), Rails will not be able to find the files on its own. You still
want to be able to use the helpers you are used to like `stylesheet_link_tag`
or `image_tag`, and they should put out the correct URL for the desired asset.
This technique is referred to as *cache busting*.

So let's say you have a JavaScript file called `application.js` (for example in
`app/assets/javascripts`) and `faucet-pipeline` generates a file called
`application-03118e77692b637cfc0f55bb27fef087.js` (for example in
`public/assets/javascripts`) from that file. When you use `stylesheet_link_tag
'public/assets/javascripts/application.js'`, you expect that the resulting HTML
points to the file containing the hash in its filename. To do that,
`faucet-pipeline` generates a manifest files for each type of asset. In this
case, it needs to generate a file called `javascript.json` in
`public/assets/manifests` (to change this, see the Configuration section). The
file should look like this:

```json
{
  "application.js": "/assets/javascripts/application-03118e77692b637cfc0f55bb27fef087.js"
}
```

And that's it. This gem will take care of the rest. The resulting HTML will look like this:

```html
<!-- ... -->
<script src="/assets/javascripts/application-03118e77692b637cfc0f55bb27fef087.js" data-turbolinks-track="reload"></script>
<!-- ... -->
```

The types supported by this gem are:

* `stylesheet`
* `javascript`
* `image`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'faucet_pipeline_rails'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install faucet_pipeline_rails
```

After this, you can ditch sprockets (aka the classic Rails asset pipeline)
for good. If you're on an existing Rails app, change the top of your 
`config/application.rb` from `require 'rails/all'` to:

```ruby
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie" # Disable sprockets
require "rails/test_unit/railtie"
```

Make sure you customize this to your actual needs. The main takeaway here is
to not require `"sprockets/railtie"` anymore.

For fresh apps, you can just skip sprockets with:

    rails new --skip-sprockets

## Configuration

By default this gem assumes that your manifest files can be found in
`public/assets/manifests`. This is a nice starting point for a `faucet.config.js`:

```js
let jsConfig = {
  manifest: {
    file: "public/assets/manifests/javascript.json",
    baseURI: (bundlePath, baseName) => `/assets/javascripts/${baseName}`
  },
  bundles: [{
    entryPoint: "./app/assets/javascripts/application.js",
    target: "public/assets/javascripts/application.js",
    externals: {}
  }]
};

let sassConfig = {
  manifest: {
    file: "public/assets/manifests/stylesheet.json",
    baseURI: (bundlePath, baseName) => `/assets/stylesheets/${baseName}`
  },
  assets: [
    "public/assets/manifests/static.json"
  ],
  prefixes: {
    browsers: [ "last 2 versions" ]
  },
  bundles: [{
    entryPoint: "app/assets/stylesheets/application.scss",
    target: "public/assets/stylesheets/application.css"
  }]
};

let staticConfig = {
  manifest: {
    file: "public/assets/manifests/static.json",
    baseURI: (bundlePath, baseName) => `/assets/static/${baseName}`
  },
  bundles: [{
    source: "app/assets/images",
    target: "public/assets/static"
  }]
}

module.exports = {
  js: jsConfig,
  sass: sassConfig,
  static: staticConfig,
  watchDirs: ["app/assets"]
};
```

In this case, your `application.html.erb` would contain lines like these:

```erb
<%= stylesheet_link_tag 'public/assets/stylesheets/application.css', media: 'all', 'data-turbolinks-track': 'reload' %>
<%= javascript_include_tag 'public/assets/javascripts/application.js', 'data-turbolinks-track': 'reload' %>
```

You can change the path to the manifest fiels that with the following
configuration:

```ruby
config.x.faucet_pipeline.manifests_path = File.join("my", "own", "manifests", "path")
```

The `manifests_path` is relative to your Rails Root.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can
also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/faucet-pipeline/faucet_pipeline_rails. This project is
intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [Contributor
Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
