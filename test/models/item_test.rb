# == Schema Information
#
# Table name: items
#
#  id                 :integer          not null, primary key
#  supplier_id        :string(255)
#  internal_id        :string(255)
#  desc               :text
#  order_link         :string(255)
#  contract_desc      :string(255)
#  deliver_addr       :text
#  status             :string(255)
#  user_placed_id     :integer
#  user_resp_id       :integer
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
#  status_id          :integer
#  part_id            :integer
#  order_date         :date
#  contract_id        :integer
#

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
