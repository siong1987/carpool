class CitiesController < ApplicationController
  skip_before_action :authenticate_user!, :check_user_account_complete!

  def index
    cities = City.search(params[:query])

    render(
      json: cities.to_json(only: :id, methods: :fullname),
      root: "cities",
    )
  end
end
