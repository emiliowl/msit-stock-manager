class Supplier < ActiveRecord::Base
  attr_accessible :name, :product_ids
  has_and_belongs_to_many :products  
end
