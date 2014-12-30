# == Schema Information
#
# Table name: parts
#
#  id                 :integer          not null, primary key
#  own_id             :string(255)
#  third_id           :string(255)
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  desc               :text
#  min_cnt            :integer
#  order_link         :text
#  order_desc         :text
#  order_price        :decimal(10, 4)
#  part_type          :integer
#  order_time         :integer
#  ordering_person_id :integer
#

require 'test_helper'

class PartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
