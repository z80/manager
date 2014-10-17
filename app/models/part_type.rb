# == Schema Information
#
# Table name: part_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class PartType < ActiveRecord::Base
end
