# == Schema Information
#
# Table name: shipments
#
#  id          :integer          not null, primary key
#  contract_id :integer
#  desc        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class ShipmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
