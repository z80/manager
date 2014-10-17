# == Schema Information
#
# Table name: product_statuses
#
#  id         :integer          not null, primary key
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  avail      :boolean
#

class ProductStatus < ActiveRecord::Base
  attr_accessible :status
  attr_accessible :avail
end
