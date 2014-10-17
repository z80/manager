# == Schema Information
#
# Table name: prod_subtypes
#
#  id          :integer          not null, primary key
#  belongs_id  :integer
#  contains_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class ProdSubtypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
