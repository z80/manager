# == Schema Information
#
# Table name: subparts
#
#  id          :integer          not null, primary key
#  contains_id :integer
#  belongs_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  cnt         :integer
#

require 'test_helper'

class SubpartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
