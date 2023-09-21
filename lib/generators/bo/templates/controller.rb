# frozen_string_literal: true

require 'csv'

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
      @<%= class_name.underscore %>.build_<%= association.name %> if @<%= class_name.underscore %>.<%= association.name %>.nil?
    <%- end -%>
    end

    def new
      @<%= class_name.underscore %> = <%= class_name %>.new
      authorize! @<%= class_name.underscore %>, to: :new?, namespace:, strict_namespace: true
      <%- has_one_assoc.each do |association| -%>
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

    def export_csv
      @<%= class_name.pluralize.underscore %> = fetch_authorized_<%= class_name.pluralize.underscore %>
      csv_data = generate_csv_data

      send_data csv_data,
                type: 'text/csv; charset=utf-8; header=present',
                disposition: "attachment; filename=<%= class_name.pluralize.underscore %>_#{Time.zone.now}.csv"
    end

    private

    def fetch_authorized_<%= class_name.pluralize.underscore %>
      authorized_scope(
        <%=class_name%>.all,
        with: Bo::Administrators::<%=class_name%>Policy
      ).ransack(params[:q]).result(distinct: true)
    end

    def generate_csv_data
      CSV.generate(headers: true) do |csv|
        csv << translated_headers

        @<%= class_name.pluralize.underscore %>.each do |instance|
          csv << <%=class_name%>.column_names.map { |col| instance.send(col) }
        end
      end
    end

    def translated_headers
      <%=class_name%>.column_names.map do |col|
        I18n.t("bo.<%=class_name.downcase%>.attributes.#{col}")
      end
    end

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
