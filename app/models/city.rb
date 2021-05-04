class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(arrival, leave)
    available_listings = []
      listings.each do |listing|
      available_listings << listing unless listing.reservations.any?{|reservation| (Date.parse(arrival) <= reservation.checkout) && (Date.parse(leave) >= reservation.checkin)}
    end
    available_listings
  end

  def self.highest_ratio_res_to_listings
    City.all.max_by do |city|
      res = city.reservations.count
      city_listings = city.listings.count
      res.to_f/city_listings
    end
  end

  def self.most_res
    City.all.max_by do |city| 
      city.reservations.count
    end
  end
end