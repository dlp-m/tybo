# frozen_string_literal: true

class AttachmentsListComponent < ViewComponent::Base
  renders_many :attachments, AttachmentCardComponent
end
