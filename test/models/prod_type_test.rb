# == Schema Information
#
# Table name: prod_types
#
#  id                 :integer          not null, primary key
#  part_id            :integer
#  own_id             :string(255)
#  desc               :text
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  user_id            :integer
#

require 'test_helper'

class ProdTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
