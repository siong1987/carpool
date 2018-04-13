class Carpool < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  validates :user, presence: true

  belongs_to :from_city, class_name: "City", foreign_key: "from_city_id"
  validates :from_city, presence: true
  validate :from_city_cannot_be_absent

  belongs_to :to_city, class_name: "City", foreign_key: "to_city_id"
  validates :to_city, presence: true
  validate :to_city_cannot_be_absent

  validates :note, presence: true

  def from_city_cannot_be_absent
    unless City.where(id: from_city_id).exists?
      errors.add(:from_city_id, "can't be absent")
    end
  end

  def to_city_cannot_be_absent
    unless City.where(id: to_city_id).exists?
      errors.add(:to_city_id, "can't be absent")
    end
  end

  def self.search(from_city, to_city)
    from_cities_id = City.near([from_city.latitude, from_city.longitude], 10).map(&:id)
    to_cities_id = City.near([to_city.latitude, to_city.longitude], 10).map(&:id)

    Carpool.includes(:from_city, :to_city).where(from_city_id: from_cities_id, to_city_id: to_cities_id)
  end
end
