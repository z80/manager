# == Schema Information
#
# Table name: warehouses
#
#  id                 :integer          not null, primary key
#  w_id               :string(255)
#  w_desc             :text
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

require 'test_helper'

class WarehouseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
