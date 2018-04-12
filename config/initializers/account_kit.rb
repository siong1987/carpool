require "facebook/account_kit"

Facebook::AccountKit.config do |c|
  c.account_kit_version = "v1.0" # or any other valid account kit api version
  c.account_kit_app_secret = Rails.application.credentials.facebook[:account_kit_secret]
  c.facebook_app_id = Rails.application.credentials.facebook[:app_id]
end
