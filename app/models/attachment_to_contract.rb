# == Schema Information
#
# Table name: attachment_to_contracts
#
#  id            :integer          not null, primary key
#  attachment_id :integer
#  contract_id   :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class AttachmentToContract < ActiveRecord::Base
  attr_accessible :attachment_id
  attr_accessible :contract_id

  def attachment
    if ( Attachment.exists?( self.attachment_id ) )
      img = Image.find( self.attachment_id )
      return img
    end
    return nil
  end

end
