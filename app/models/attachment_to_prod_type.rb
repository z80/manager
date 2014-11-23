# == Schema Information
#
# Table name: attachment_to_prod_types
#
#  id            :integer          not null, primary key
#  attachment_id :integer
#  prod_type_id  :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class AttachmentToProdType < ActiveRecord::Base
  attr_accessible :attachment_id
  attr_accessible :prod_type_id

  def attachment
    if ( Attachment.exists?( self.attachment_id ) )
      img = Image.find( self.attachment_id )
      return img
    end
    return nil
  end

end
