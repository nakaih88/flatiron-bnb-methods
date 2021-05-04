class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validate :can_not_make_reservation_on_your_own, :listing_is_available?, :checkin_before_checkout
  validates :checkin, presence: true
  validates :checkout, presence: true

  def can_not_make_reservation_on_your_own
    if self.listing.host_id == self.guest_id
      errors.add(:id, "can not make reservation")
    end
  end


  def listing_is_available?
    if checkin && checkout
      (self.checkin..self.checkout).each do |day|
        if self.listing.is_reserved?(day)
          errors.add(:checkin, "dates are not available")
          break;
        elsif self.checkin == self.checkout
          errors.add(:id, "checkin and checkout can't be the same")
        end
      end
    end
  end

  def checkin_before_checkout
    if checkin && checkout
      if self.checkin > self.checkout
        errors.add(:id, "checkin must be before checkout")
      end
    end
  end

  def duration
  		(self.checkout - self.checkin).to_i
  end

  def total_price
  		self.listing.price * self.duration
  end

end