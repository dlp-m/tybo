# Tybo_

## tymate's backoffice components

This is a collection of components built on [Tailwind CSS](https://tailwindcss.com) and [ViewComponent](https://viewcomponent.org). Its purpose is to allow us to easily and quickly build administration tools for our APIs.

## Installation

1. Add the gem to your Gemfile : `gem 'backoffice-components', '~> 0.0.1'`
2. Run `bundle install`
3. Add the gem's HTML templates to the `config/tailwind.config.js` file :

```js
module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/components/**/*.html.erb',
    process.env.BACKOFFICE_COMPONENTS_GEM_PATH
  ],
  // ...
}
```

```
# local example
export BACKOFFICE_COMPONENTS_GEM_PATH=../../.gem/ruby/*/gems/backoffice-components-*/lib/app/components/**/*.html.erb

# scalingo example
BACKOFFICE_COMPONENTS_GEM_PATH=./vendor/bundle/ruby/*/gems/backoffice-components-*/lib/app/components/**/*.html.erb
```
