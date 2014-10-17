module ImagesHelper
  def init_images( imageToClazz, clazz_id_sym )
    @@imageToClazz = imageToClazz
    @@clazz_id_sym      = clazz_id_sym
  end

  def add_image( image, desc, id )
    att = Image.new
    att.avatar = file
    att.desc = desc
    if not att.save then
      return nil
    end

    att2clazz = @@imageToClazz.new
    att2clazz.image_id  = att.id
    att2clazz.send( @@clazz_id_sym.to_sym, id )
    if ( not att2clazz.save ) then
      att.delete
      return nil
    end

    return att
  end


  def images( id )
    att2clazzs = @@imageToClazz.where( self.clazz_id_sym.to_sym => id )
    atts = []
    att2clazzs.each do|att2clazz|
      if ( Image.exists?( att2clazz.attachment_id ) ) then
        atts.append( Image.find( att2clazz.attachment_id ) )
      end
    end
    return atts
  end

end




