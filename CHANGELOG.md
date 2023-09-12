### 0.2.2
- readjust spacing between titles in form
- remove useless br in forms template
### 0.2.0
- :warning: remove the 'target_top' from index and add in your `_model_name.html.erb` a turbo frame  tag with a target '_top' 
  eg: for a `BlogPost` model :
```
# _blog_post.html.erb
<%= turbo_frame_tag "blog_posts", target: '_top' do %> # add this
  <%= render(FormComponent.new(item: blog_post)) do |form| %>
    <% current_page = if blog_post.persisted?
                      { label: I18n.t('bo.show'), path: administrators_blog_post_path(blog_post) }
                    else
                      { label: I18n.t('bo.blog_post.new').capitalize, path: new_administrators_blog_post_path }
                    end
      form.with_title(blog_post.persisted? ? blog_post.title : I18n.t('bo.blog_post.new').capitalize)
      form.with_breadcrumb([
            { label: I18n.t('bo.blog_post.others').capitalize, path: administrators_blog_posts_path },
            current_page
          ]) %>
      <br>
      <%= render "form", blog_post: @blog_post %>
  <% end %>
<% end %> # add this
```
- add better paginations
### 0.1.0
- :warning: change errors and alert class for customisation.
  add 'red-alert' colors in your `config/tailwind.config.js`
  ```js
  colors: {
    tybo: {
      ...
    },
    'red-alert': {
      DEFAULT: '#d0342c',
      '50': '#fdf3f3',
      '100': '#fde4e3',
      '200': '#fbcfcd',
      '300': '#f8ada9',
      '400': '#f17e78',
      '500': '#e7544c',
      '600': '#d0342c',
      '700': '#b12b24',
      '800': '#932721',
      '900': '#7a2622',
      '950': '#42100d',
    }
  }
  ```
- add better translations
- fix the Tailwind CSS classes that were not being interpreted dynamically
### 0.0.40
- add translations for pagination Previous & Next buttons, separator 'to' of DateSearchComponent
### 0.0.39
- fix paginations errors
### 0.0.38
- fix translations errors
### 0.0.37
- fix attachments component
### 0.0.36
- add better turbo link
- fix policy namespace error
- fix attachment component path
### 0.0.34
- Raise error if the model argument doesn't exist
- Add routes check to prevent duplication
### 0.0.33
- add components search form date_fields 
- better html.erb generated
- Add some translations for actions
### 0.0.32
- add components for search form fields
### 0.0.19
- disable turbo for devise reset password
### 0.0.18
- disable turbo for devise forms
### 0.0.17
- disable turbo for devise session form
### 0.0.16
- move policy namespace into parent controller
- add translations for show view and create view
- remove some params into permited_params 
### 0.0.15
- add new configurable images for bo sidebar
add into `tybo.rb`
```
  config.nav_logo_url = 'nav_logo.png'
```
### 0.0.14
- add translated labels for base fields
### 0.0.13
- add labels for action_text fields
- add policies for all ressources
  you need to regenerate bo views and controllers or add it manualy and add your policy errors logic in ApplicationController eg:
```
  rescue_from ActionPolicy::Unauthorized, with: :not_authorized

  def not_authorized
    flash[:alert] = I18n.t('bo.unauthorized')
    redirect_to(request.referrer || root_path)
  end
```
- add in RessourceController ( eg: AdministratorController )
```
  authorize :user, through: :current_administrator
```

### 0.0.12
- :warning: add in your translations files `bo.locale.yml` and for all devices ressources
  eg for `Administrator`: 
  ```
    bo:
      devise:
        sign_in_as:
          administrator: 'Espace administrateur'
  ```
### before - 0.0.12
- update `Tybo.rb` and add config images url
  eg: 
  ```
  Tybo.configure do |config|
    # customise logo and cover url
    # should be an external url or image should be present in (app/assets/images)
    config.logo_url = 'lmj_logo_text_colored.svg'
    config.cover_url = 'lmj_logo_text_colored.svg'
  end
  ```
