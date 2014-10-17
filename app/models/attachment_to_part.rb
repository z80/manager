# == Schema Information
#
# Table name: attachment_to_parts
#
#  id            :integer          not null, primary key
#  attachment_id :integer
#  part_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class AttachmentToPart < ActiveRecord::Base
  attr_accessible :attachment_id
  attr_accessible :part_id

  def attachment
    if ( Attachment.exists?( self.attachment_id ) )
      img = Image.find( self.attachment_id )
      return img
    end
    return nil
  end

end
