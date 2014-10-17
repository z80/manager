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

class ImageToPart < ActiveRecord::Base
  attr_accessible :image_id
  attr_accessible :part_id

  def image
    if ( Image.exists?( self.image_id ) )
      img = Image.find( self.image_id )
      return img
    end
    return nil
  end
end
