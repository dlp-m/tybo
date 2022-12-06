# Tybo_

## tymate's backoffice components

This is a collection of components built on [Tailwind CSS](https://tailwindcss.com) and [ViewComponent](https://viewcomponent.org). Its purpose is to allow us to easily and quickly build administration tools for our APIs.

## Installation

1. Add the gem to your Gemfile : `gem 'tybo', '~> 0.0.2'`
2. Run `bundle install`
3. Add the gem's HTML templates to the `config/tailwind.config.js` file :

```js
module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/components/**/*.html.erb',
    process.env.TYBO_GEM_PATH
  ],
  // ...
}
```

```
# local example
export TYBO_GEM_PATH=../../.gem/ruby/*/gems/tybo-*/lib/app/components/**/*.html.erb

# scalingo example
TYBO_GEM_PATH=./vendor/bundle/ruby/*/gems/tybo-*/lib/app/components/**/*.html.erb
```
4. Run `bin/importmap pin @tymate/tybo`
5. Edit `app/javascript/controllers/application.js` with :

```js
import { Application } from "@hotwired/stimulus"

// First import the different controllers needed from tybo
import { Attachments, Questions } from "@tymate/tybo"

const application = Application.start()

// then register all of them inside the Stimulus application
// with the correct name
application.register('attachments', Attachments)
application.register('questions', Questions)

window.Stimulus   = application

export { application }
```

## Development

### Ruby gem

To put a new version online, it is necessary to :

1. Ensure all your changes are saved and commited.
2. Make sure that all new components are autoloaded in `lib/tybo.rb`
3. Update the version number in `tybo.gemspec`
4. Run `gem build tybo.gemspec`
5. Run `gem push tybo-<version number>.gem`

### NPM/JSPM package

The Stimulus controllers required for the components to work properly must be published in an NPM package and then listed on JSPM so that they can be loaded by importmaps.

To put a new version online, it is necessary to :
1. Update the version number in the `package.json` file.
2. Run `npm run build`
3. GET `https://api.jspm.io/build/@tymate/tybo@<version number>` in order to build a queue request on JSPM
4. Once the request is processed (it is possible to track through the [JSPM:Generator](https://generator.jspm.io)), retrieve the new link and update it in the `config/importmap.rb` of the Rails project.
