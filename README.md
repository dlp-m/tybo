# Tybo

A custom admin engine for Ruby on Rails

  

## Installation

Add this line to your application's Gemfile:

  

```ruby

gem  'tybo'

```

  

And

```bash

$ bundle install

```

Then execute the generator

```bash

$ bundle exec rails g tybo_install

```

## Policy
add your policy logic in ApplicationController eg:
```
  rescue_from ActionPolicy::Unauthorized, with: :not_authorized


  def not_authorized
    flash[:alert] = I18n.t('bo.unauthorized')
    redirect_to(request.referrer || root_path)
  end
```

## Customize

**Update images**: change image url in `config/initializer/tybo.rb`
```
  config.logo_url = 'your_logo.png'
  config.nav_logo_url = 'your_nav_logo.png'
  config.cover_url = 'your_cover.png'
```

**Customize colors**: Change the `tybo` colors  class in `tailwind.config.js`, 
you can use https://uicolors.app/create to generate complete palette

## Contributing

Contribution directions go here.

  

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
