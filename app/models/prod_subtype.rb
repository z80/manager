# == Schema Information
#
# Table name: prod_subtypes
#
#  id          :integer          not null, primary key
#  belongs_id  :integer
#  contains_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class ProdSubtype < ActiveRecord::Base
  attr_accessible :contains_id
  attr_accessible :belongs_id
end
