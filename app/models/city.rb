class City < ApplicationRecord
  validates :place_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :state, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  def complete
    name.present? && state.present? && latitude.present? && longitude.present?
  end

  def fullname
    "#{name}, #{state}"
  end

  def self.search(search_term)
    return City.none if search_term.blank?

    # Update our DB with places
    predictions = City.search_google_maps(search_term)
    place_ids = update_place_details(predictions)
    City.where(place_id: place_ids).order_by_place_ids(place_ids)
  end

  # ref: http://stackoverflow.com/questions/1309624/simulating-mysqls-order-by-field-in-postgresql
  def self.order_by_place_ids(ids)
    return City.none if ids.empty?
    order_by = ["case"]
    ids.each_with_index.map do |id, index|
      order_by << "WHEN place_id='#{id}' THEN #{index}"
    end
    order_by << "end"
    order(order_by.join(" "))
  end

  # Docs: https://developers.google.com/places/web-service/autocomplete#place_autocomplete_results
  # url: https://maps.googleapis.com/maps/api/place/autocomplete/json
  # param: types=(regions)
  # param: components=country:US
  # param: key
  # param: input
  # Returns a list of auto-complete results
  private_class_method
  def self.search_google_maps(search_term)
    Rails.cache.fetch("google-search-#{CityHash.hash64(search_term)}") do
      url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
      params = {}
      params[:key] = Rails.application.credentials.google[:api_key]
      params[:components] = "country:MY"
      params[:types] = "(regions)"
      params[:input] = search_term
      response = get(url + params.to_query)

      predictions = JSON.parse(response.body)["predictions"]
      predictions
    end
  end

  # Note - this has the potential to fan out requests very quickly,
  # so only the first 5 place IDs will be considered.
  private_class_method
  def self.update_place_details(predictions)
    remapped_predictions = [] # List of place ids

    predictions.first(5).each do |prediction|
      city = fill_place_details(prediction)

      # This is necessary because sometimes we have a city in the DB that matches our city + state
      # name, but has a different place id. In this case we want to tell the caller "we got a city,
      # but the city you think is place id X is actually place id Y".
      remapped_predictions << city.place_id unless city.nil?
    end
    remapped_predictions
  end

  # Docs: https://developers.google.com/places/web-service/details#PlaceDetailsResults
  # url: https://maps.googleapis.com/maps/api/place/details/json
  # param: key
  # param: placeid
  # Searching for - lat / lng, City Name
  private_class_method
  def self.fill_place_details(prediction)
    place_id = prediction["place_id"]
    saved_city = City.find_by(place_id: place_id)
    return saved_city if saved_city&.complete

    url = "https://maps.googleapis.com/maps/api/place/details/json?"
    params = {}
    params[:key] = Rails.application.credentials.google[:api_key]
    params[:place_id] = place_id
    response = get(url + params.to_query)

    city_name = nil
    state_name = nil
    latitude = nil
    longitude = nil

    begin
      parsed_json = JSON.parse(response.body)
      parsed_json["result"]["address_components"].each do |address_component|
        address_component["types"].each do |type|
          city_name = address_component["long_name"] if type == "sublocality"

          if type == "locality" && city_name.blank?
            # Only take locality if we couldnt find a sublocality
            city_name = address_component["long_name"]
          end

          if type == "administrative_area_level_1"
            state_name = address_component["long_name"]
          end
        end
      end

      latitude = parsed_json["result"]["geometry"]["location"]["lat"]
      longitude = parsed_json["result"]["geometry"]["location"]["lng"]
    rescue => exception
      Bugsnag.notify(exception)
      return nil
    end

    return nil unless city_name.present? &&
                      state_name.present? &&
                      latitude.present? &&
                      longitude.present?

    begin
      existing_city = City.where(name: city_name, state: state_name).first
      existing_city.presence || City.find_or_create_by(place_id: place_id) do |city|
        city.place_id = place_id
        city.name = city_name
        city.state = state_name
        city.latitude = latitude
        city.longitude = longitude
      end
    rescue => exception
      # TODO: enable bugsnag
      # Bugsnag.notify(exception)
      return nil
    end
  end

  private_class_method
  def self.get(url)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    request.content_type = "application/json"

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end
  end
end
