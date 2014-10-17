module AttachmentsHelper

  def init_attachments( attachmentToClazz, clazz_id_sym )
    @@attachmentToClazz = attachmentToClazz
    @@clazz_id_sym      = clazz_id_sym
  end

  def add_attachment( file, desc, id )
    att = Attachment.new
    att.file = file
    att.desc = desc
    if not att.save then
      return nil
    end

    att2clazz = @@attachmentToClazz.new
    att2clazz.attachment_id  = att.id
    att2clazz.send( @@clazz_id_sym.to_sym, id )
    if ( not att2clazz.save ) then
      att.delete
      return nil
    end

    return att
  end


  def attachments( id )
    att2clazzs = @@attachmentToClazz.where( @@clazz_id_sym.to_sym => id )
    atts = []
    att2clazzs.each do|att2clazz|
      if ( Attachment.exists?( att2clazz.attachment_id ) ) then
        atts.append( Attachment.find( att2clazz.attachment_id ) )
      end
    end
    return atts
  end

end




