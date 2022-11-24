
class AdRepresenter
  include Rails.application.routes.url_helpers
  attr_reader :ad

  def initialize(ad)
    @ad = ad
  end

  def to_json
      {
        id: @ad.id,
        description: @ad.description,
        price: @ad.price,
        stage: @ad.stage,
        reason_for_rejection: @ad.reason_for_rejection,
        car_model: @ad.car.model.name,
        car_brand: @ad.car.model.brand.name,
        engine_capacity: @ad.car.engine_capacity,
        creation_year: @ad.car.creation_year,
        user_phone: @ad.user.phone,
        photos: @ad.photos.map{|photo| ({ photo: rails_blob_path(photo, only_path: true) })}
      }
  end
end
