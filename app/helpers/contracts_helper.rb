module ContractsHelper
  include PartsHelper

  def mark_all_parts_shipped( contract )
    items = ContractItem.where( contract_id: contract.id )
    items.each do |ci|
      product = ci.product()
      if ( product )
        product.status = 3
        product.box_id = -1 # Make sure it is not in a box anymore.
        product.save
      end
    end
  end

  def create_shipment( contract )
    shipments = Shipment.where( contract_id: contract.id )
    desc = "Shipment #{shipments.size+1}"
    s = Shipment.new
    s.contract_id = contract.id
    s.desc = desc
    if ( not s.save )
      return false, "Failed to create shipment"
    end

    contract_items = ContractItem.where( contract_id: params[ :id ] )
    cis = []
    contract_items.each do |ci|
      cis.append( ci )
    end

    contract_shipped = true
    cis.each do |ci|
      product = ci.product()
      if ( product )
        ci.contract_id = -1
        ci.shipment_id = s.id
        if ( not ci.save )
          return false, "Failed to create shipment"
        end
        product.status = 3
        product.box_id = -1 # Make sure it is not in a box anymore.
        product.save
      else
        contract_shipped = false
      end
    end

    if ( contract_shipped )
      contract.shipped = true
      contract.save
    end
    return true
  end

  def add_contract_item( contract, prod_type_id )
    prod_type = ProdType.find( prod_type_id )
    subtypes = prod_type.subproducts

    # Create root contract item.
    root_item = ContractItem.new
    root_item.contract_id  = contract.id
    root_item.prod_type_id = prod_type_id
    root_item.save


    #Create child contract items.
    subtypes.each do |a|
      prod_subtype = a[ :subtype ]
      prod_type    = a[ :type ]

      ci = ContractItem.new
      ci.contract_id  = @contract.id
      ci.prod_type_id = prod_type.id
      ci.superitem_id = root_item.id
      ci.save
    end

  end

  def remove_contract_item( contract_item_id )
    ci = ContractItem.find( contract_item_id )
    # Remove all tree only if root item is removed.
    # Don't remove all tree if subitem is removed.
    #root_item = ci.superitem_id
    #ci = root_item if ( root_item )

    subitems = ContractItem.where( superitem_id: ci.id )
    subitems.each do |item|
      item.delete
      item.save
    end

    ci.delete
    ci.save
  end


  # Contract possible warning levels:
  # Green:        all in stock and assigned
  # Green-yellow: all in stock nut not assigned
  # Yellow:       not all in stock but could be assembled with parts in stock.
  # Orange:       not all in stock for assembly but could be purchased in time and days remaining after pruchase for assembly.
  # Red:          can't be purchased in time.



  def active_contracts()
    a = Contract.order( "ship_date desc" ).where( shipped: false )
    res = []
    a.each do |c|
      res.append( [ c.name, c.id ] )
    end

    return res
  end
end
