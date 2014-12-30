# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  prod_type_id  :integer
#  serial_number :string(255)
#  desc          :text
#  status        :integer
#  created_at    :datetime
#  updated_at    :datetime
#  box_id        :integer
#  owner_id      :integer
#

class Product < ActiveRecord::Base
  attr_accessible :prod_type_id
  attr_accessible :serial_number
  attr_accessible :desc
  attr_accessible :status
  attr_accessible :box_id
  attr_accessible :owner_id

  has_one :product_status, as: :status

  def part_number()
    pt = prod_type
    if ( pt )
      return pt.own_id
    end
    return "Unspecified"
  end

  def status_stri()
    if ( not ProductStatus.exists?( self.status ) )
      return "Unspecified"
    end
    s = ProductStatus.find( self.status )
    return s.status
  end

  def avail?()
    if ( not ProductStatus.exists?( self.status ) )
      return false
    end
    s = ProductStatus.find( self.status )
    #return s.avail
    # Make only "in stock" and "In the office" products available for contracts estimation.
    a = s.for_sale?
    return a
  end

  def prod_type()
    if ( not ProdType.exists?( self.prod_type_id ) )
      return nil
    end
    pt = ProdType.find( self.prod_type_id )
    return pt
  end

  def assigned?()
    res = ContractItem.exists?( product_id: self.id )
    return res
  end

  # Assigns the same status to all tree of products.
  def set_status( st )
    pt = prod_type()
    spts = pt.subproducts
    spts.each do |pair|
      pt = pair[ :type ]
      prods = Product.where( belongs_to: self.id )
      prods.each do |product|
        product.set_status( st )
      end
    end

    self.status = st
    self.save
  end

  def image()
    img = prod_type.image_ex
    return img
  end

  def contract()
    res = ContractItem.exists?( product_id: self.id )
    if ( not res )
      return nil
    end
    ci = ContractItem.find_by_product_id( self.id )
    if ( not Contract.exists?( ci.contract_id ) )
      # May be shipment exists?
      if ( not Shipment.exists?( ci.shipment_id ) )
        return nil
      end
      sh = Shipment.find( ci.shipment_id )
      if ( not Contract.exists?( sh.contract_id ) )
        return nil
      end
      contract = Contract.find( sh.contract_id )
      return contract
    end
    contract = Contract.find( ci.contract_id )
    return contract
  end

  def box()
    res = Box.exists?( self.box_id )
    if ( not res )
      return nil
    end
    res = Box.find( self.box_id )
    return res
  end

  def add_attachment( file, desc )
    att = Attachment.new
    att.file = file
    att.desc = desc
    if not att.save then
      return nil
    end

    att2clazz = AttachmentToProduct.new
    att2clazz.attachment_id = att.id
    att2clazz.product_id    = self.id
    if ( not att2clazz.save ) then
      att.delete
      return nil
    end

    return att
  end


  def attachments()
    att2clazzs = AttachmentToProduct.where( product_id: self.id )
    atts = []
    att2clazzs.each do |att2clazz|
      if ( Attachment.exists?( att2clazz.attachment_id ) ) then
        atts.append( Attachment.find( att2clazz.attachment_id ) )
      end
    end
    return atts
  end

end
