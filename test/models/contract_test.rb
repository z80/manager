# == Schema Information
#
# Table name: contracts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  desc       :text
#  ship_date  :date
#  shipped    :boolean
#  created_at :datetime
#  updated_at :datetime
#  warning    :integer
#  number     :string(255)
#  owner_id   :integer
#  box_id     :integer
#

require 'test_helper'

class ContractTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
