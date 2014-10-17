# == Schema Information
#
# Table name: item_statuses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ItemStatus < ActiveRecord::Base
end
