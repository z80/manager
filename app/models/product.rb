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
#

class Product < ActiveRecord::Base
  attr_accessible :prod_type_id
  attr_accessible :serial_number
  attr_accessible :desc
  attr_accessible :status
  attr_accessible :box_id

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
    return s.avail
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
end
