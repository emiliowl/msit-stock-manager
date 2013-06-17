class Product < ActiveRecord::Base
  attr_accessible :name, :supplier_ids
  has_and_belongs_to_many :suppliers
end
