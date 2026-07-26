## 0.7.0 — Breaking changes

### What's new

- **Dedicated CSS build** : Tybo now ships its own `tybo_admin.css` instead of writing into `application.tailwind.css`. The engine exposes `bin/rails tybo:build_css` and `bin/rails tybo:watch_css` Rake tasks (loaded automatically, no copy needed). `assets:precompile` hooks into `tybo:build_css` automatically.
- **Isolated JS entry point** : a dedicated `application_tybo_admin.js` is generated in `app/javascript/tybo/`. Admin layouts use `javascript_importmap_tags "application_tybo_admin"` — no longer injecting into the host app's `application.js`.
- **Puma plugin** : `plugin :tybo` injected into `config/puma.rb` starts the CSS watch automatically when running `bin/rails server` in development.
- **Namespaced Stimulus controllers** : all controllers are now registered under the `tybo--` namespace (`tybo--sidebar`, `tybo--flash`, etc.) following the official Stimulus convention for engines.

---

### Upgrade from 0.6.x

#### 1. CSS

Remove references to `tailwind.css` from your admin layouts and replace with `tybo_admin.css`:

```erb
<%# before %>
<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
<%= stylesheet_link_tag "tailwind", "inter-font", "data-turbo-track": "reload" %>

<%# after %>
<%= stylesheet_link_tag "tybo_admin", "data-turbo-track": "reload" %>
```

Create `app/assets/stylesheets/tybo_admin.tailwind.css` (copy the content from your existing `application.tailwind.css` if you had customised it), then build:

```shell
bin/rails tybo:build_css
```

For development watch mode, add `plugin :tybo` to `config/puma.rb`:

```ruby
plugin :tybo if ENV.fetch("RAILS_ENV", "development") == "development"
```

#### 2. JavaScript

Replace the old `@tymate/tybo_js` setup with the new entry point.

In `config/importmap.rb`, remove:
```ruby
pin "@tymate/tybo_js", to: "tybo/controllers/index.js"
```

Add:
```ruby
pin "application_tybo_admin", to: "tybo/application_tybo_admin.js"
pin_all_from "app/javascript/tybo/controllers", under: "tybo/controllers"
pin "tom-select", to: "https://esm.sh/tom-select"
pin "@rails/request.js", to: "https://esm.sh/@rails/request.js"
```

Copy the JS controllers from the engine into your app:

```shell
bin/rails g tybo_install  # or copy manually from the engine
```

Create `app/javascript/tybo/application_tybo_admin.js`:

```javascript
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"

import Attachments from "tybo/controllers/attachments_controller"
import Dropdown from "tybo/controllers/dropdown_controller"
import Flash from "tybo/controllers/flash_controller"
import SearchForm from "tybo/controllers/search_form_controller"
import TsSearch from "tybo/controllers/ts/search_controller"
import TsSelect from "tybo/controllers/ts/select_controller"
import Sidebar from "tybo/controllers/sidebar_controller"

const application = Application.start()

application.register("tybo--attachments", Attachments)
application.register("tybo--dropdown", Dropdown)
application.register("tybo--flash", Flash)
application.register("tybo--search-form", SearchForm)
application.register("tybo--ts--search", TsSearch)
application.register("tybo--ts--select", TsSelect)
application.register("tybo--sidebar", Sidebar)
```

Update your admin layouts to use the new JS entry point:

```erb
<%# before %>
<%= javascript_importmap_tags %>

<%# after %>
<%= javascript_importmap_tags "application_tybo_admin" %>
```

Remove the old Tybo registrations from your `app/javascript/controllers/application.js` if present:

```javascript
// remove these lines
import { Dropdown, Flash, SearchForm, TsSearch, TsSelect, Sidebar } from "@tymate/tybo_js"
application.register('dropdown', Dropdown)
application.register('flash', Flash)
// etc.
```

#### 3. Stimulus data-controller attributes

All generated views and engine components now use the `tybo--` prefix. If you have **manually written** views that reference old controller names, update them:

| Before | After |
|---|---|
| `data-controller="sidebar"` | `data-controller="tybo--sidebar"` |
| `data-controller="flash"` | `data-controller="tybo--flash"` |
| `data-controller="dropdown"` | `data-controller="tybo--dropdown"` |
| `data-controller="search-form"` | `data-controller="tybo--search-form"` |
| `data-controller="ts--select"` | `data-controller="tybo--ts--select"` |
| `data-controller="ts--search"` | `data-controller="tybo--ts--search"` |
| `data-controller="attachments"` | `data-controller="tybo--attachments"` |
| `data-sidebar-target="..."` | `data-tybo--sidebar-target="..."` |
| `data-dropdown-target="..."` | `data-tybo--dropdown-target="..."` |
| `action: "input->search-form#search"` | `action: "input->tybo--search-form#search"` |

#### 4. Translations

Add the missing key to your `config/locales/bo.en.yml` and `bo.fr.yml`:

```yaml
bo:
  add_ressource_btn: "+"
```

---

### Tybo version 0.5.x
Require tailwwind v3
### 0.4.0

Update your all `model_name.html.erb` with the following HTML structure.
Example for `administrator.html.erb`:
```erb
<body class="h-full bg-home">
  <div>
    <% if administrator_signed_in? %>
      <%= render('administrators/layouts/side_bar') %>
    <% end %>
    <div class="lg:pl-72">
      <main class="py-10">
        <div class="px-4 sm:px-6 lg:px-8">
          <%= yield %>
        </div>
      </main>
    </div>
  </div>
</body>
```
Make sure the body structure matches this format to ensure compatibility with the update.
Update tybo_js dependencie with:
```shell
./bin/importmap pin @tymate/tybo_js@0.1.3
```
And import `Sidebar` in your `application.js`
````javascript
import { Dropdown, Flash, SearchForm, TsSearch, TsSelect, Sidebar } from "@tymate/tybo_js"
...
application.register('sidebar', Sidebar)
```

### 0.3.0
To add a CSV export with Tybo, you need to add the following methods.
Example for a BlogPost model:

In `app/controllers/administrators/blog_posts_controller.rb`, add the following methods:
```ruby
  def export_csv
    @blog_posts = fetch_authorized_blog_posts
    csv_data = generate_csv_data

    send_data csv_data,
              type: 'text/csv; charset=utf-8; header=present',
              disposition: "attachment; filename=#{I18n.t('bo.blog_post.others')}_#{Time.zone.now}.csv"
  end

  private

  def fetch_authorized_blog_posts
    authorized_scope(
      BlogPost.all,
      with: Bo::Administrators::BlogPostPolicy
    ).ransack(params[:q]).result(distinct: true)
  end

  def generate_csv_data
    CSV.generate(headers: true) do |csv|
      csv << translated_headers

      @blog_posts.each do |instance|
        csv << BlogPost.column_names.map { |col| instance.send(col) }
      end
    end
  end

  def translated_headers
    BlogPost.column_names.map do |col|
      I18n.t("bo.blogpost.attributes.#{col}")
    end
  end
```

Add the route:
```ruby
  resources :blog_posts do
    get 'export_csv', on: :collection
  end
```
In `app/views/administrators/blog_posts/index.html.erb`, you need to modify the turbo frame to encompass the entire view and add before `header.with_add_button`:
```ruby
  <%= header.with_export_button(path: export_csv_administrators_blog_posts_path(format: :csv, params: {q: params.permit!['q']}))%>
```
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
