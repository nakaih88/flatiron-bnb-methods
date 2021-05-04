class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true
  after_create :user_host_status
  after_destroy :user_host_status



  def average_review_rating
    self.reviews.average(:rating)
  end

  def is_reserved?(day)
    self.reservations.each do |res|
      if day.between?(res.checkin, res.checkout)
        return true
      end
    end

    return false
  end


  private


  def user_host_status
    if self.host.listings.empty?
      self.host.update(host: false)
    else
      self.host.update(host: true)
    end
  end


end