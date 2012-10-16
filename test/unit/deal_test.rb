require 'test_helper'

class DealTest < ActiveSupport::TestCase
  test "factory should be sane" do
    assert FactoryGirl.build(:deal).valid?
  end
  
  test "publisher returns correct publisher" do 
    d = FactoryGirl.create(:deal)
    assert d.advertiser.publisher.name, d.publisher
  end
  
  #Changed previous test to give ample time to prevent
  #occasional hiccup depending on developer's machine speeds
  test "over should honor current time" do
    time = Time.zone.now
    end_at = time + 5.minutes
  	deal = FactoryGirl.create(:deal, :end_at => end_at)
  	
  	#Should not be over because it has 5 minutes
  	assert !deal.over?, "Deal should not be over"
  	
  	#reset deal time end to original timestamp.  Deal will be over because
  	#current_time > end_at (original timestamp)
  	deal.end_at = time
  	assert deal.over?, "Deal should be over"
  end  
  
  ############## OLD Test ###############################
  # # I think this is a bad test and it fails sometimes
  # test "over should honor current time" do
  #   deal = FactoryGirl.create(:deal, :end_at => Time.zone.now + 0.01)
  #   assert !deal.over?, "Deal should not be over"
  #   sleep 1
  #   assert deal.over?, "Deal should be over"
  # end  
  #######################################################
end
