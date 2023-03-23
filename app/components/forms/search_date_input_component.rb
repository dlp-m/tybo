# frozen_string_literal: true

class Forms::SearchDateInputComponent < ViewComponent::Base
  def initialize(label:, form:, field:)
    @label = label
    @field = field
    @form = form
    @from_field = from_field
    @to_field = to_field
  end

  def from_field
    "#{@field}_from_date".to_sym
  end

  def to_field
    "#{@field}_to_date".to_sym
  end
end
