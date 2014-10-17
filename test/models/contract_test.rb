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
#

require 'test_helper'

class ContractTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
