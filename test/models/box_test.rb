# == Schema Information
#
# Table name: boxes
#
#  id           :integer          not null, primary key
#  box_id       :string(255)
#  desc         :text
#  created_at   :datetime
#  updated_at   :datetime
#  warehouse_id :integer
#

require 'test_helper'

class BoxTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
