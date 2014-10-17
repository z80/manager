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

require 'test_helper'

class ProductStatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
