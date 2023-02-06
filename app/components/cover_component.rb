class CoverComponent < ViewComponent::Base
  def initialize(url: Tybo.configuration.cover_url)
    @url = url
  end
end
