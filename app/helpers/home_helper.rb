module HomeHelper
  def facebook_redirect_url
    return "https://#{ENV["DOMAIN"]}/session/" if ENV["DOMAIN"]

    "http://localhost:3000/session/"
  end
end
