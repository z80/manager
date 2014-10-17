# == Schema Information
#
# Table name: image_to_parts
#
#  id         :integer          not null, primary key
#  image_id   :integer
#  part_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ImageToPartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
