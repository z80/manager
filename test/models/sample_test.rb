# == Schema Information
#
# Table name: samples
#
#  id          :integer          not null, primary key
#  from        :text
#  desc        :text
#  received    :datetime
#  due         :datetime
#  user_placed :integer
#  user_resp   :integer
#  created_at  :datetime
#  updated_at  :datetime
#  location    :text
#  status      :integer
#  warn_days   :integer
#  box_id      :integer
#

require 'test_helper'

class SampleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
