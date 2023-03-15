# frozen_string_literal: true

class BoGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)
  require_relative "./utils/translations.rb"

  check_class_collision suffix: 'bo'
  class_option :namespace, type: :string, default: 'administrators'

  def create_bo_file
    # Template method
    # First argument is the name of the template
    # Second argument is where to create the resulting file. In this case, app/bo/my_bo.rb
    template 'new.html.erb', File.join("app/views/#{options[:namespace]}", "#{plural_name}/new.html.erb")
    template 'item.html.erb', File.join("app/views/#{options[:namespace]}", "#{plural_name}/_#{file_name.underscore}.html.erb")
    template '_form.html.erb', File.join("app/views/#{options[:namespace]}", "#{plural_name}/_form.html.erb")
    template 'index.html.erb', File.join("app/views/#{options[:namespace]}", "#{plural_name}/index.html.erb")
    template '_table.html.erb', File.join("app/views/#{options[:namespace]}", "#{plural_name}/_table.html.erb")
    template '_search_bar.html.erb', File.join("app/views/#{options[:namespace]}", "#{plural_name}/_search_bar.html.erb")
    template 'show.html.erb', File.join("app/views/#{options[:namespace]}", "#{plural_name}/show.html.erb")
    template 'controller.rb', File.join("app/controllers/#{options[:namespace]}", "#{plural_name}_controller.rb")
    template 'policy.rb', File.join("app/policies/bo/#{options[:namespace]}", "#{file_name.underscore}_policy.rb")
    unless File.exists?("app/policies/bo/#{options[:namespace]}.rb")
      template 'namespace_policy.rb', "app/policies/bo/#{options[:namespace]}_policy.rb"
    end
    create_translations
  end


  def add_link_to_side_bar
    inject_into_file "app/views/#{options[:namespace]}/layouts/_side_bar.html.erb", before: "  <%= sidebar.with_current_user_card(user: current_#{options[:namespace].singularize}) %>\n" do 
      "  <%= sidebar.with_item(path: #{options[:namespace]}_#{plural_name}_path, icon: Icons::UsersComponent, label: I18n.t('bo.#{file_name}.others').capitalize) %>\n"
    end
  end

  def create_routes
    inject_into_file 'config/routes.rb', after: " namespace :#{options[:namespace]} do\n" do 
      "    resources :#{plural_name} \n"
    end
  end

  private

  def bo_model
    class_name.constantize
  end

  def plural_name
    file_name.pluralize
  end

  def model_columns
    bo_model.column_names.map(&:to_sym)
  end

  def simple_form_conflict_keywords
    %w[country country_code]
  end

  def bo_model_title(model=nil)
    return unless model

   (%i[title name email id] & model.column_names.map(&:to_sym)).first
  end

  def excluded_columns
    %i[id created_at updated_at]
  end

  def permited_params
    params = {}
    permitted_columns&.map do |col|
      params["#{col}".to_sym] = nil
    end
    storage_assoc&.map do |col|
      params["#{col.name.to_s.remove('_attachment' )}".to_sym] = nil
    end
    rich_text_assoc&.map do |col|
      params["#{col.name.to_s.remove('rich_text_')}".to_sym] = nil
    end
    has_many_assoc&.map do |association|
       params["#{association.name.to_s.singularize}_ids".to_sym] = []
    end
    has_one_assoc&.map do |association|
      attributes = association.klass.column_names.map(&:to_sym).delete_if { |attr| excluded_columns.include?(attr) }
      params["#{association.name.to_s.singularize}_attributes".to_sym] = attributes
    end
    params
  end

  def has_many_assoc
    bo_model.reflect_on_all_associations(:has_many)
  end

  def belongs_to_assoc
    bo_model.reflect_on_all_associations(:belongs_to)
  end

  def has_one_assoc
    excluded = ['ActiveStorage::Attachment', 'ActionText::RichText', 'ActiveStorage::Blob']
    bo_model.reflect_on_all_associations(:has_one).reject do |assoc|
       excluded.include?(assoc.options[:class_name])
    end
  end

  def storage_assoc
    bo_model.reflect_on_all_associations(:has_one).select do |assoc|
      assoc.options[:class_name] == 'ActiveStorage::Attachment'
    end
  end

  def rich_text_assoc
    bo_model.reflect_on_all_associations(:has_one).select do |assoc|
      assoc.options[:class_name] == 'ActionText::RichText'
    end
  end

  def permitted_columns
    model_columns - excluded_columns
  end

end
