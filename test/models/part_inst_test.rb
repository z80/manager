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

require 'test_helper'

class PartInstTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
