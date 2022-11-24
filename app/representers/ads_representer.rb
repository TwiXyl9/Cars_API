class AdsRepresenter
  include Rails.application.routes.url_helpers
  attr_reader :ads

  def initialize(ads)
    @ads = ads
  end

  def to_json
    ads.map do |ad|
      AdRepresenter.new(ad).to_json
    end
  end
end
