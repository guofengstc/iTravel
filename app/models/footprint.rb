class Footprint < ActiveRecord::Base
  belongs_to :user
  attr_accessible :address, :desc, :latitude, :longitude
  
  has_many :footprint_images
end
