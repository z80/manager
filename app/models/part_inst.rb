# == Schema Information
#
# Table name: part_insts
#
#  id         :integer          not null, primary key
#  part_id    :integer
#  box_id     :integer
#  cnt        :integer
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class PartInst < ActiveRecord::Base
  belongs_to :part
  belongs_to :box
  belongs_to :user

  attr_accessible :part_id
  attr_accessible :box_id
  attr_accessible :cnt

end
