# == Schema Information
#
# Table name: logs
#
#  id         :integer          not null, primary key
#  msg        :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

require 'test_helper'

class LogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
