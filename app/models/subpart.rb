# == Schema Information
#
# Table name: subparts
#
#  id          :integer          not null, primary key
#  contains_id :integer
#  belongs_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  cnt         :integer
#

class Subpart < ActiveRecord::Base
  #include AttachmentsHelper
  #include ImagesHelper

  #init_attachments( AttachmentToPart, :part_id )
  #init_images( ImageToPart, :part_id )


  belongs_to :part
  attr_accessible :contains_id
  attr_accessible :belongs_id
  attr_accessible :cnt

  def contains
      part = Part.find( self.contains_id )
  end

  def belongs
      part = Part.find( self.belongs_id )
  end

  def add_image( image, desc )
    att = Image.new
    att.avatar = image
    att.desc = desc
    if not att.save then
      return nil
    end

    att2clazz = ImageToSubpart.new
    att2clazz.image_id  = att.id
    att2clazz.subpart_id = self.id
    if ( not att2clazz.save ) then
      att.delete
      return nil
    end

    return att
  end


  def images()
    att2clazzs = ImageToSubpart.where( subpart_id: self.id )
    atts = []
    att2clazzs.each do|att2clazz|
      if ( Image.exists?( att2clazz.image_id ) ) then
        atts.append( Image.find( att2clazz.image_id ) )
      end
    end
    return atts
  end

  def add_attachment( file, desc )
    att = Attachment.new
    att.file = file
    att.desc = desc
    if not att.save then
      return nil
    end

    att2clazz = AttachmentToSubpart.new
    att2clazz.attachment_id = att.id
    att2clazz.subpart_id    = self.id
    if ( not att2clazz.save ) then
      att.delete
      return nil
    end

    return att
  end


  def attachments()
    att2clazzs = AttachmentToSubpart.where( subpart_id: self.id )
    atts = []
    att2clazzs.each do|att2clazz|
      if ( Attachment.exists?( att2clazz.attachment_id ) ) then
        atts.append( Attachment.find( att2clazz.attachment_id ) )
      end
    end
    return atts
  end


end
