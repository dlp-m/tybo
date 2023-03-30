# frozen_string_literal: true

include Turbo::FramesHelper, Turbo::Streams::StreamName, Turbo::Streams::Broadcasts

class AttachmentCardComponent < ViewComponent::Base
  def initialize(attachment:, url:)
    @attachment = attachment
    @url = url
  end
end
