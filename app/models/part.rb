# == Schema Information
#
# Table name: parts
#
#  id                 :integer          not null, primary key
#  own_id             :string(255)
#  third_id           :string(255)
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  desc               :text
#  min_cnt            :integer
#  order_link         :text
#  order_desc         :text
#  order_price        :decimal(10, 4)
#  part_type          :integer
#  order_time         :integer
#  ordering_person_id :integer
#

class Part < ActiveRecord::Base
  #include AttachmentsHelper
  #include ImagesHelper

  #init_attachments( AttachmentToPart, :part_id )
  #init_images( ImageToPart, :part_id )

  has_attached_file    :image, :styles => { :medium => "512x512>", :thumb => "128x128>" }, :default_url => "/images/:style/missing.png"
  validates_attachment :image, #:presence => true,  
                               #:content_type => { :content_type => ["image/jpg", "image/gif", "image/png"] },
                               :size => { :in => 0..256.kilobytes }, 
                               :path => ":rails_root/public/images/avatars/:id/:style_:basename.:extension", 
                               :url  => "/app/assets/images/article_images/:id/:style_:basename.:extension"

  has_many   :parts, through: :subparts
  has_many   :subparts
  has_many   :part_insts
  belongs_to :user

  attr_accessible :own_id
  attr_accessible :third_id
  attr_accessible :user_id
  attr_accessible :desc
  attr_accessible :min_cnt
  attr_accessible :order_link
  attr_accessible :order_price
  attr_accessible :order_desc
  attr_accessible :part_type
  attr_accessible :order_time
  attr_accessible :ordering_person_id

  def cnt()
    insts = PartInst.where( part_id: self.id )
    n = 0
    insts.each do |pi|
      n += ( pi.cnt or 0 )
    end
    #puts '#######################################'
    #puts 'cnt = ' + n.to_s
    #puts '#######################################'
    return n
  end

  def critical_cnt?()
    #puts '********************************'
    if ( not self.min_cnt )
      #puts 'No min_cnt'
      return false
    end
    #puts 'Here!'
    #puts '********************************'
    return ( cnt() <= self.min_cnt )
  end

  def has_subparts?()
    sps = Subpart.where( belongs_id: self.id )
    return ( sps.size > 0 )
  end

  # Here name 'all_subparts' to get objects of type Part - not Subpart.
  def all_subparts()
      sps = Subpart.where( belongs_id: self.id )
      parts = []
      sps.each do |sp|
        part = Part.exists?( sp.contains_id ) ? Part.find( sp.contains_id ) : nil
        if ( part )
          parts.append( part )
        end
      end
      return parts
  end

  def all_superparts()
    sps = Subpart.where( contains_id: self.id )
    pp = {}
    sps.each do |sp|
      part = Part.exists?( sp.belongs_id ) ? Part.find( sp.belongs_id ) : nil
      if part
        pp[ part.id ] = ( pp[ part.id ] ) ? 
                              ( pp[ part.id ] + sp.cnt ) : 
                              sp.cnt
      end
    end

    parts = []
    pp.each do |id, cnt|
      parts.append( { part: Part.find( id ), cnt: cnt } )
    end
    return parts
  end

  def parts_missing( cnt )
    cnt ||= 1
    cnt = cnt.to_i
    id = self.id
    part = self
    subparts = parts_needed( part, cnt )
    available = []
    subparts.each do |sp|
      part_insts = PartInst.where( part_id: sp[:id] )
      cnt = 0
      part_insts.each do |pi|
        if ( pi.cnt > 0 ) then
          cnt += pi.cnt
          available.append( pi )
          break if ( cnt >= sp[:cnt] )
        end
      end
      sp[:cnt] -= cnt
    end

    missing = []
    subparts.each do |sp|
      missing.append( sp ) if ( sp[:cnt] > 0 )
    end
    return (missing.size > 0) ? missing : nil
  end

  def insts_to_take_from( cnt )
    cnt ||= 1
    cnt = cnt.to_i
    id = self.id
    part = self
    subparts = parts_needed( part, cnt )
    available = []
    needed    = []
    subparts.each do |sp|
      needed.append( { id: sp[:id], cnt: sp[:cnt]} )
      part_insts = PartInst.where( part_id: sp[:id] )
      cnt = sp[ :cnt ]
      part_insts.each do |pi|
        if ( pi.cnt > 0 ) then
          take_cnt = ( cnt <= pi.cnt ) ? cnt : pi.cnt
          available.append( { pi: pi, cnt: take_cnt } )
          cnt -= pi.cnt
          break if ( cnt <= 0 )
        end
      end
      sp[:cnt] -= cnt
    end

    return available, needed
  end

  def type_name
    t = self.part_type || -1
    if ( PartType.exists?( t ) )
      pt = PartType.find( t )
      return pt.name
    end
    return 'Unspecified'
  end


  def add_image( image, desc )
    att = Image.new
    att.avatar = image
    att.desc = desc
    if not att.save then
      return nil
    end

    att2clazz = ImageToPart.new
    att2clazz.image_id  = att.id
    att2clazz.part_id = self.id
    if ( not att2clazz.save ) then
      att.delete
      return nil
    end

    return att
  end


  def images()
    att2clazzs = ImageToPart.where( part_id: self.id )
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

    att2clazz = AttachmentToPart.new
    att2clazz.attachment_id = att.id
    att2clazz.part_id       = self.id
    if ( not att2clazz.save ) then
      att.delete
      return nil
    end

    return att
  end


  def attachments()
    att2clazzs = AttachmentToPart.where( part_id: self.id )
    atts = []
    att2clazzs.each do|att2clazz|
      if ( Attachment.exists?( att2clazz.attachment_id ) ) then
        atts.append( Attachment.find( att2clazz.attachment_id ) )
      end
    end
    return atts
  end

  def order_days
    # To make default value.
    return (self.order_time || 7)
  end

  def place_order( cnt, params = {} )
    item = Item.new
    item.part_id = self.id
    #item.image   = self.image

    item.supplier_id  = self.third_id
    item.internal_id  = self.own_id
    item.desc         = self.order_desc
    item.order_link   = self.order_link
    item.contract_id  = params[:contract_desc] || "AUTO ORDER"
    item.deliver_addr = params[:addr] || "USA"
    item.user_placed  = params[:user_placed_id]
    item.user_resp    = params[:user_resp_id]
    item.set_sz       = 1
    item.sets_cnt     = cnt
    item.unit_price   = self.order_price
    item.comment      = "Automatically generated"
    item.status_id    = params[:status_id] || 1

    item.save
  end

  def order_items( contract_id = nil )
    ordered_ind = -1
    to_be_ordered_ind = -1
    delivered_ind = -1
    iss = ItemStatus.all
    iss.each do |is|
      if ( is.name == "To be ordered" )
        to_be_ordered_ind = is.id
      elsif ( is.name == "Ordered" )
        ordered_ind = is.id
      elsif ( is.name == "Delivered" )
        delivered_ind = is.id
      end
    end
    items = Item.where( part_id: self.id ).where( status_id: [ ordered_ind, to_be_ordered_ind, delivered_ind ] )
    if ( contract_id )
      items = items.where( contract_id: contract_id )
    end
    return items
  end

  def ordered_cnt( contract_id = nil )
    items = order_items( contract_id )
    cnt = 0
    items.each do |item|
      cnt += item.cnt
    end
    return cnt, items
  end

  def boxes()
    pis = PartInst.where( part_id: self.id )
    boxes = []
    pis.each do |pi|
      box = Box.find( pi.box_id )
      boxes.append( {box: box, inst: pi} )
    end
    return boxes
  end

  def order_price_stri()
    a = self.order_price || 0.0
    a = "%6.3f" % a
    return a
  end

  def ordering_person_stri
    p = User.exists?( self.ordering_person_id ) ? User.find( self.ordering_person_id ) : nil
    if p
      return p.name + ' ' + p.surname
    end
    return 'Unspecified'
  end

private

  def parts_needed( part, cnt )
    cnt ||= 1
    id = part.id
    subparts = Subpart.where( belongs_id: id )
    subs = []
    subparts.each do |sp|
      sp_cnt = cnt * sp.cnt
      subs.append( { id: sp.contains_id, cnt: sp_cnt } )
    end
    # Merge identical parts
    subparts = []
    subs.each do |a|
      cnt = 0
      if (a[ :cnt ] > 0) then
        subs.each do |b|
          if ( a[ :id ] == b[ :id ] ) then
            cnt += b[ :cnt ]
            b[ :cnt ] = 0
          end
        end
      end
      subparts.append( { id: a[:id], cnt: cnt } )
    end
    return subparts
  end

  # Part types
  @@TYPE_NONE           = 0
  @@TYPE_PURCHASABLE    = 1
  @@TYPE_3RD_PRODUCIBLE = 2

end
