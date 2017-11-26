# OliveBranch

[![Maintainability](https://api.codeclimate.com/v1/badges/592cc7b1375885adc557/maintainability)](https://codeclimate.com/github/ericproulx/olive_branch/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/592cc7b1375885adc557/test_coverage)](https://codeclimate.com/github/ericproulx/olive_branch/test_coverage)
[![Build Status](https://travis-ci.org/ericproulx/olive_branch.svg?branch=master)](https://travis-ci.org/ericproulx/olive_branch)

This gem lets your API users pass in and receive camelCased or dash-cased keys, while your Rails app receives and produces snake_cased ones.

## Install

1. Add this to your Gemfile and then `bundle install`:

        gem "olive_branch", git: 'https://github.com/ericproulx/olive_branch.git'
        
## Use Rails

The middleware will be automatically added through Railtie

Include a `X-Key-Inflection` header with values of `camel`, `dash`, or `snake` in your JSON API requests.

## Configuration

```ruby
# config/initializers/olive_branch.rb
OliveBranch.configuration do |config|
  config.camelize = # your camelize function ( Default: string.underscore.camelize(:lower))
  config.dasherize = # your dasherize function ( Default: string.dasherize)
  config.content_type_check = # your content type check function ( Default: 'application/json')
  config.default_inflection = # if you don't want to include the header key in every request, you can default an inflection
  config.header_key = # your header key ( Default: HTTP_X_KEY_INFLECTION )
end
```
* * *

OliveBranch is released under the [MIT License](http://www.opensource.org/licenses/MIT). See MIT-LICENSE for further details.

* * *

<a href="http://code.viget.com">
  <img src="http://code.viget.com/github-banner.png" alt="Code At Viget">
</a>

Visit [code.viget.com](http://code.viget.com) to see more projects from [Viget.](https://viget.com)
