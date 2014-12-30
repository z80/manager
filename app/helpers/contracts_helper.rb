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

  def create_shipment( contract, date )
    contract_items = items_by_date( contract, nil, date )
    cis = []
    contract_items.each do |ci|
      cis.append( ci )
    end

    if ( cis.size < 1 )
      return false, "No items for shipment"
    end

    shipments = Shipment.where( contract_id: contract.id )
    desc = "Shipment #{shipments.size+1}"
    s = Shipment.new
    s.contract_id = contract.id
    s.desc = desc
    if ( not s.save )
      return false, "Failed to create shipment"
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
        product.status = ProductStatus.status_at_clients_site()
        product.box_id = -1 # Make sure it is not in a box anymore.
        product.save
      else
        # If no product it could be complex product with subproducts.
        if ( ci.has_subitems?())
          subs = ci.subitems()
          subs.each do |sci|
            # If at least one subitem is not shipped - complex product is not shiped.
            if ( sci.contract_id == contract.id )
              contract_shipped = false
              break
            end
          end
          # All subitems are shipped.
          ci.contract_id = -1
          ci.shipment_id = s.id
          if ( not ci.save )
            return false, "Failed to create shipment"
          end
        else
          # Just unassigned product.
          contract_shipped = false
        end
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

    ind = ContractItem.where( contract_id: contract.id ).size+1

    # Create root contract item.
    root_item = ContractItem.new
    root_item.contract_id  = contract.id
    root_item.prod_type_id = prod_type_id
    root_item.number       = ind.to_s
    root_item.save

    ind += 1


    #Create child contract items.
    subtypes.each do |a|
      prod_subtype = a[ :subtype ]
      prod_type    = a[ :type ]

      ci = ContractItem.new
      ci.contract_id  = @contract.id
      ci.prod_type_id = prod_type.id
      ci.superitem_id = root_item.id
      ci.number       = ind.to_s
      ind += 1
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

  def items_by_date( contract, sort_by, date_id, inv=false )
    event = ShipDate.exists?( date_id )
    if ( event )
      date = ShipDate.find( date_id )
      date = date.date
    else
      date = nil
    end

    all_dates = ShipDate.where( contract_id: contract.id )
    sd = all_dates.where( date: date )
    if ( sd && ( sd.size > 0 ) )
      date = sd.first.date
    else
      date = nil
    end

    cis = ContractItem.where( contract_id: contract.id )
    if ( sort_by == "number" )
      cis = cis.order( "number ASC" )
    end
    if not date
      @contract_items = cis
    else
      @contract_items = []
      cis.each do |ci|
        if not inv
          @contract_items.append( ci ) if ci.ship_date <= date
        else
          @contract_items.append( ci ) if ci.ship_date > date
        end
      end
    end
    return @contract_items
  end



  def copy_contract( contract )

    def create_superitem( src, dest, res_items )
      sci = src.superitem
      if sci
        if not res_items[ sci ]
          # If superitem is not created yet
          s_item = ContractItem.new
          s_item.contract_id  = dest.id
          s_item.prod_type_id = ci.prod_type_id
          res = s_item.save
          if not res
            return false, 'Failed to create superitem.'
          end
          res_items[ sci ] = s_item
          # Check if it exists is built in the function itself.
          create_superitem( sci, s_item, res_items )
        else
          s_item = res[ sci ]
        end
        dest.superitem_id = s_item.id
      end
      return true
    end

    src = contract
    dest = Contract.new
    dest.name = src.name + " (copy)"
    dest.desc = src.desc
    dest.ship_date = src.ship_date
    dest.shipped   = false
    dest.warning   = src.warning
    dest.owner_id  = src.owner_id
    dest.box_id    = src.box_id
    if ( not dest.save )
      return false, 'Error: failed to copy this contract!'
    end

    items = []
    cis = ContractItem.where( contract_id: src.id )
    cis.each do |ci|
      items.append( ci )
    end

    shipments = Shipment.where( contract_id: src.id )
    shipments.each do |shipment|
      cis = ContractItem.where( shipment_id: shipment.id )
      cis.each do |ci|
        items.append( ci )
      end
    end

    res_items = {}
    # Iterate over items and create new ones.
    items.each do |ci|
      if not res_items[ ci ]
        item = ContractItem.new
        item.contract_id  = dest.id
        item.prod_type_id = ci.prod_type_id

        res, err = create_superitem( ci, item, res_items )
        if ( not res )
          return false, err
        end

        res = item.save
        if not res
          return false, 'Failed to save item.'
        end
      end
    end

    return dest
  end
end
