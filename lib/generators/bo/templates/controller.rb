# frozen_string_literal: true

module <%= options[:namespace].camelize %>
  class <%= class_name.pluralize %>Controller < <%= options[:namespace].singularize.camelize %>Controller
    before_action :set_<%= class_name.underscore %>, only: %i[show edit destroy update]

    def index
      @q = authorized_scope(
        <%=class_name%>.all,
        with: Bo::<%= options[:namespace].camelize %>::<%= class_name %>Policy
      ).ransack(params[:q])
      @pagy, @<%= class_name.pluralize.underscore %> = pagy(@q.result(distinct: true))
    end

    def show
      authorize! @<%= class_name.underscore %>, to: :show?, namespace:, strict_namespace: true
    <%- has_one_assoc.each do |association| -%>
    <%- next if association.options[:class_name] == "ActionText::RichText" -%>
      @<%= class_name.underscore %>.build_<%= association.name %> if @<%= class_name.underscore %>.<%= association.name %>.nil?
    <%- end -%>
    end

    def new
      @<%= class_name.underscore %> = <%= class_name %>.new
      authorize! @<%= class_name.underscore %>, to: :new?, namespace:, strict_namespace: true
      <%- has_one_assoc.each do |association| -%>
      <%- next if association.options[:class_name] == "ActionText::RichText" -%>
      @<%= class_name.underscore %>.build_<%= association.name %>
      <%- end -%>
    end

    def edit
      authorize! @<%= class_name.underscore %>, to: :edit?, namespace:, strict_namespace: true
    end

    def create
      @<%= class_name.underscore %> = <%= class_name %>.new(<%= class_name.underscore %>_params)
      authorize! @<%= class_name.underscore %>, to: :create?, namespace:, strict_namespace: true

      if @<%= class_name.underscore %>.save
        flash[:success] = t('bo.record.created')
        redirect_to <%="#{options[:namespace]}_#{class_name.underscore.pluralize}_path"%>
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      authorize! @<%= class_name.underscore %>, to: :update?, namespace:, strict_namespace: true

      if @<%= class_name.underscore %>.update(<%= class_name.underscore %>_params)
        flash[:success] = t('bo.record.updated')
        redirect_to <%="#{options[:namespace]}_#{class_name.underscore}_path"%>
      else
        render :show, status: :unprocessable_entity
      end
    end

    def destroy
      authorize! @<%= class_name.underscore %>, to: :destroy?, namespace:, strict_namespace: true

      @<%= class_name.underscore %>.destroy
      flash[:success] = t('bo.record.destroyed')

      redirect_to <%="#{options[:namespace]}_#{class_name.underscore.pluralize}_path"%>, status: :see_other
    end

    private

    def set_<%= class_name.underscore %>
      @<%= class_name.underscore %> = authorized_scope(
        <%= class_name %>.all,
        with: Bo::<%= options[:namespace].camelize %>::<%= class_name %>Policy
      ).find(params[:id])
    end

    def <%= class_name.underscore %>_params
      params.require(:<%= class_name.underscore %>).permit(
      <%-permited_params.each_with_index do |(key, value), index| -%>
        <%- if value.nil? -%>
        :<%= key %><%=permited_params.count == (index +1) ? '' : ',' %>
        <%- else -%>
        <%= "#{key}: %i[#{value.join(" ")}]" %><%=permited_params.count == (index +1) ? '' : ',' %>
        <%- end -%>
        <%- end -%>
      )
    end
  end
end
