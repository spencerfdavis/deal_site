class Deal < ActiveRecord::Base
  belongs_to :advertiser
  
  cattr_reader :per_page
  @@per_page = 10  

  validates_presence_of :advertiser, :value, :price, :description, :start_at, :end_at

  def publisher
    advertiser.publisher.name
  end

  def over?
    Time.zone.now > end_at
  end

  def savings_as_percentage
    0.5
  end

  def savings
    20
  end
end
