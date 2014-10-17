# == Schema Information
#
# Table name: image_to_samples
#
#  id         :integer          not null, primary key
#  image_id   :integer
#  sample_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class ImageToSample < ActiveRecord::Base
  attr_accessible :image_id
  attr_accessible :sample_id
end
