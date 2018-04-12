class User < ApplicationRecord
  validates :facebook_user_id, presence: true, uniqueness: true
  validates :phone_number, presence: true
  validates :phone_country_prefix, presence: true
  validates :phone_national_number, presence: true

  has_one :ride

  def has_ride?
    ride.present?
  end

  def self.validate(code)
    token_exchanger = Facebook::AccountKit::TokenExchanger.new(code)
    access_token = token_exchanger.fetch_access_token

    user = Facebook::AccountKit::UserAccount.new(access_token)
    user_info = user.fetch_user_info

    User.where(facebook_user_id: user_info["id"]).first_or_create do |new_user|
      new_user.facebook_user_id = user_info["id"]
      new_user.phone_number = user_info["phone"]["number"]
      new_user.phone_country_prefix = user_info["phone"]["country_prefix"]
      new_user.phone_national_number = user_info["phone"]["national_number"]
    end
  end

  def account_complete?
    name.present?
  end
end
