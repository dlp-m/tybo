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
- /!\ add in your translations files `bo.locale.yml` and for all devices ressources
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
