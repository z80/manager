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
#  number       :string(255)
#  ship_date_id :integer
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

  def subitems()
    si = ContractItem.where( superitem_id: self.id )
    return si
  end

  def client_visible?( include_all=false )
    pt = prod_type()
    # client_visible has actually opposite meaning, e.i. invisible.
    if ( pt && pt.client_visible )
      return false
    end
    if ( include_all )
      return true
    end
    num = self.number
    if not num
      return false
    end
    if ( num.include?( '.' ) )
      return false
    end
    return true
  end

  def contract
    c = Contract.exists?( self.contract_id )
    if not c
      return nil
    end
    c = Contract.find( self.contract_id )
    return c
  end

  def ship_date
    sd = ShipDate.exists?( self.ship_date_id )
    if not sd
      c = contract
      if not c
        d = Date.today
        return d
      end
      d = c.ship_date
      return d
    end
    sd = ShipDate.find( self.ship_date_id )
    d = sd.date
    return d || Date.today
  end
end
