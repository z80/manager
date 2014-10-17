# == Schema Information
#
# Table name: contracts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  desc       :text
#  ship_date  :date
#  shipped    :boolean
#  created_at :datetime
#  updated_at :datetime
#  warning    :integer
#

class Contract < ActiveRecord::Base
  attr_accessible :name
  attr_accessible :desc
  attr_accessible :ship_date
  attr_accessible :shipped
  attr_accessible :warning

  def assigned?
    items = ContractItem.where( contract_id: self.id )
    items.each do |ci|
      #puts "product: "
      #puts ci.product()
      #debugger
      # If really assignable item and not assigned.
      if ( ( not ci.has_subitems?() ) && ( not ci.product() ) )
        return false
      end
    end
    return true
  end






  def product_types( prod_types = {}, only_unassigned = false )
    cis = ContractItem.where( contract_id: self.id )
    
    cis.each do |ci|
      if ( not ci.has_subitems?() )
        if ( ( not only_unassigned ) || ( not ci.product() ) )
          pt_id = ci.prod_type_id
          pt = ProdType.find( pt_id )
          prod_types[ pt ] ||= 0
          prod_types[ pt ] += 1
        end
      end
    end
    return prod_types
  end

  # Returns Hash with Part objects as keys and cnts as values
  def self.parts_not_in_stock( prod_types, only_unassigned = false )
    if ( only_unassigned )
      assigned = {}
      contracts = Contract.where( shipped: false )
      contracts.each do |contract|
        cis = ContractItem.where( contract_id: contract.id )
        cis.each do |ci|
          if ( ci.product() )
            assigned[ ci.prod_type_id ] ||= 0
            assigned[ ci.prod_type_id ] += 1
          end
        end
      end
    end

    missing = {}
    prod_types.each do |pt, cnt|
      in_stock = pt.cnt
      in_stock += pt.cnt_for_import
      if ( only_unassigned )
        assigned_cnt = assigned[ pt.id ] || 0
        in_stock -= assigned_cnt
      end
      needed_cnt = cnt - in_stock
      if pt.part
        missing[ pt.part.id ] = needed_cnt if ( needed_cnt > 0 )
      end
    end
    return missing
  end

  def self.parts_forecast( missing, stock=nil )
    # All parts in stock
    if ( not stock )
      prts = Part.all
      stock = {}
      prts.each do |part|
        stock[ part.id ] = part.cnt
      end
    end

    could   = {}
    couldnt = {}
    parts_to_purchase = {}
    max_time = 0

    # Total parts/complex_parts needed for contract
    missing.each do |part_id, cnt|
      part = Part.find( part_id )
      parts, complex_parts = ApplicationController.helpers.parts_needed( part, -1, cnt, false )

      # Parse "complex_parts" and if in stock subtract 
      # corresponding parts from "parts" and "complex_parts" 
      # from original "complex_parts".
      complex_parts.each do |part_id, cnt|
        in_stock_cnt = stock[ part_id ] || 0
        subtract_cnt = ( cnt <= in_stock_cnt ) ? cnt : in_stock_cnt
        if ( subtract_cnt > 0 )
          # Subtract from stock.
          stock[part_id]         -= subtract_cnt
          # Subtract from complex_parts Hash.
          #complex_parts[part_id] -= subtract_cnt
          # Subtract from original "parts" content of appropriate complex part.
          c_part = Part.find( part_id )
          c_parts, c_complex_parts = ApplicationController.helpers.parts_needed( part, -1, subtract_cnt )
          c_parts.each do |c_part_id, c_cnt|
            parts[c_part_id] ||= 0
            parts[c_part_id] -= c_cnt
          end
        end
      end

      # Parse "parts" and subtract from "stock" remaining amount of parts.
      parts.each do |p_part_id, p_cnt|
        stock[ p_part_id ] ||= 0
        stock[ p_part_id ] -= p_cnt
      end

      #Check stock
      can_produce = true
      stock_copy = {}
      stock.each do |s_part_id, s_cnt|
        if (s_cnt < 0)
          parts_to_purchase[s_part_id] ||= 0
          parts_to_purchase[s_part_id] -= s_cnt
          can_produce = false
        else
          stock_copy[ s_part_id ] = s_cnt
        end
      end

      # Update stock for the next part.
      # It is to make parts calculation separate and pro prevent previous
      # negative counts to interfere current part under consideration.
      stock = stock_copy
        
      # If parts number is negative, parts should be 
      # purchased. And immediate assembly is impossible.
      if can_produce
        could[ part_id ] ||= 0
        could[ part_id ] += cnt
      else
        couldnt[ part_id ] ||= 0
        couldnt[ part_id ] += cnt
      end

      parts_to_purchase.each do |pp_part_id, pp_cnt|
        part = Part.find( pp_part_id )
        days = part.order_days
        max_time = days if ( max_time < days )
      end

    end
    # As a result 
    # 1) Could be assembled id all stock[%id] >= 0
    # 2) Couldn't be assembled if parts to purchase:  stock[%id] <= 0
    return could, couldnt, parts_to_purchase, max_time, stock
  end

  def self.ids_to_parts( hash )
    res = {}
    hash.each do |id, cnt|
      part = Part.find( id )
      res[ part ] ||= 0
      res[ part ] += cnt
    end
    return res
  end

  def contract_report()
    contracts = Contract.order( "ship_date desc" ).where( shipped: false ).where( "ship_date <= ?", self.ship_date )
    
    stock = nil
    could = {}
    couldnt = {}
    parts_to_purchase = {}
    max_days = 0

    # Process all past contracts. Count products needed and derive corresponding part cnt needed.
    summary = {}
    contracts.each do |contract|
      if ( contract.id != self.id )
        summary = contract.product_types( summary, true )
      end
    end
    needed_before = Contract.parts_not_in_stock( summary, true )

    contracts.each do |contract|
      if ( contract.id != self.id )
        could_1, couldnt_1, parts_to_purchase_1, max_days_1, stock = Contract.parts_forecast( needed_before, stock )

        could_1.each do |part_id, part_cnt|
          could[ part_id ] = (could[ part_id ]) ? (could[ part_id ] + part_cnt) : part_cnt
        end
        couldnt_1.each do |part_id, part_cnt|
          couldnt[ part_id ] = (couldnt[ part_id ]) ? (couldnt[ part_id ] + part_cnt) : part_cnt
        end
        parts_to_purchase_1.each do |part_id, part_cnt|
          parts_to_purchase[ part_id ] = (parts_to_purchase[ part_id ]) ? (parts_to_purchase[ part_id ] + part_cnt) : part_cnt
        end
        max_days = (max_days > max_days_1) ? max_days : max_days_1
      end
    end

    # To count requirements only for particular project but with parts 
    # needed for all previous projects already subtracted.
    could = {}
    couldnt = {}
    parts_to_purchase = {}
    max_days = 0

    # Calculate particular project influence in product types needed by subtracting after and before.
    summary = product_types( summary, true )
    needed_after = Contract.parts_not_in_stock( summary, true )
    needed = {}
    needed_after.each do |prod_type, after_cnt|
      before_cnt = needed_before[prod_type] || 0
      if ( before_cnt != after_cnt )
        needed[prod_type] = after_cnt - before_cnt
      end
    end

    could_1, couldnt_1, parts_to_purchase_1, max_days_1, stock = Contract.parts_forecast( needed, stock )

    could_1.each do |part_id, part_cnt|
      could[ part_id ] = (could[ part_id ]) ? (could[ part_id ] + part_cnt) : part_cnt
    end
    couldnt_1.each do |part_id, part_cnt|
      couldnt[ part_id ] = (couldnt[ part_id ]) ? (couldnt[ part_id ] + part_cnt) : part_cnt
    end
    parts_to_purchase_1.each do |part_id, part_cnt|
      parts_to_purchase[ part_id ] = (parts_to_purchase[ part_id ]) ? (parts_to_purchase[ part_id ] + part_cnt) : part_cnt
    end
    max_days = (max_days > max_days_1) ? max_days : max_days_1

    days_to_assemble  = ( self.ship_date - Date.today - max_days - 1 ).to_i
    could             = Contract.ids_to_parts( could )
    couldnt           = Contract.ids_to_parts( couldnt )
    parts_to_purchase = Contract.ids_to_parts( parts_to_purchase )
    return could, couldnt, parts_to_purchase, days_to_assemble
  end

  def warning_level( could, couldnt, parts_to_purchase, days_to_assemble )
    if ( assigned? )
      return 0
    end
    if ( parts_to_purchase.size < 1 )
      return 1
    end
    if ( couldnt.size < 1 )
      return 2
    end
    if ( days_to_assemble > 0 )
      return 3
    end
    return 4
  end

  # This is a static method.
  def self.date_report( date )
    contracts = Contract.order( "ship_date desc" ).where( shipped: false ).where( "ship_date <= ?", date )
    
    stock = nil
    could = {}
    couldnt = {}
    parts_to_purchase = {}
    max_days = 0
    total_summary = {}

    # Process all past contracts.
    contracts.each do |contract|
      summary = contract.product_types()
      summary.each do |prod_type, cnt|
        total_summary[ prod_type ] = ( total_summary[ prod_type ] ) ? 
                                            total_summary[ prod_type ] + cnt : 
                                            cnt
      end
    end

    needed = Contract.parts_not_in_stock( total_summary )
    could, couldnt, parts_to_purchase, max_days, stock = Contract.parts_forecast( needed, stock )

    days_to_assemble  = ( (date - Date.today).to_i - max_days - 1 ).to_i
    could             = Contract.ids_to_parts( could )
    couldnt           = Contract.ids_to_parts( couldnt )
    parts_to_purchase = Contract.ids_to_parts( parts_to_purchase )
    return total_summary, could, couldnt, parts_to_purchase, days_to_assemble
  end


end
