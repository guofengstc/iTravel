class FootprintImage < ActiveRecord::Base
  belongs_to :footprint
  attr_accessible :src
end
