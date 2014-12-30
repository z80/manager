# == Schema Information
#
# Table name: contract_items
#
#  id           :integer          not null, primary key
#  contract_id  :integer
#  prod_type_id :integer
#  product_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#  superitem_id :integer
#  shipment_id  :integer
#  number       :string(255)
#  ship_date_id :integer
#

require 'test_helper'

class ContractItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
