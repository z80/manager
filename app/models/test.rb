# == Schema Information
#
# Table name: tests
#
#  id         :integer          not null, primary key
#  msg        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Test < ActiveRecord::Base
  attr_accessible :msg
end
