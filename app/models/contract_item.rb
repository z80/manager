# == Schema Information
#
# Table name: contract_items
#
#  id           :integer          not null, primary key
#  contract_id  :integer
#  prod_type_id :integer
#  product_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#  superitem_id :integer
#  shipment_id  :integer
#

class ContractItem < ActiveRecord::Base
  attr_accessible :contract_id
  attr_accessible :prod_type_id
  attr_accessible :product_id
  
  def prod_type()
    if ( not ProdType.exists?( self.prod_type_id ) )
      return nil
    end
    res = ProdType.find( self.prod_type_id )
    return res
  end

  def product()
    #debugger
    if ( not Product.exists?( self.product_id ) )
      return nil
    end
    res = Product.find( self.product_id )
    #debugger
    return res
  end

  def superitem()
    id = self.superitem_id
    if ( ( not id ) || ( not ContractItem.exists?( id ) ) )
      return nil
    end
    item = ContractItem.find( id )
    return item
  end

  def has_subitems?()
    si = ContractItem.where( superitem_id: self.id )
    cnt = si.size
    return true if (cnt > 0)
    return false
  end
end
