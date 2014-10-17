# == Schema Information
#
# Table name: items
#
#  id                 :integer          not null, primary key
#  supplier_id        :string(255)
#  internal_id        :string(255)
#  desc               :text
#  order_link         :string(255)
#  contract_id        :string(255)
#  deliver_addr       :text
#  status             :string(255)
#  user_placed        :integer
#  user_resp          :integer
#  set_sz             :integer
#  sets_cnt           :integer
#  unit_price         :decimal(10, 4)
#  comment            :text
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  status_i           :integer
#  part_id            :integer
#

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
