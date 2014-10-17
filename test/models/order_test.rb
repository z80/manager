# == Schema Information
#
# Table name: orders
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  desc                    :text
#  status                  :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
