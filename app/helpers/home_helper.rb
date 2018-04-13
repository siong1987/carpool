module HomeHelper
  def facebook_redirect_url
    return "https://#{domain}/session/" if domain = ENV["DOMAIN"]

    "http://localhost:3000/session/"
  end
end
