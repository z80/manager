# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  prod_type_id  :integer
#  serial_number :string(255)
#  desc          :text
#  status        :integer
#  created_at    :datetime
#  updated_at    :datetime
#  box_id        :integer
#

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
