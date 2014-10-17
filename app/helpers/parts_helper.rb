module PartsHelper


    def search( clazz, stri, columns )
        if (not stri) or ( stri.length < 1 ) then
            return clazz.all || []
        end
        l = stri.split( /\s/i )
        res = nil
        columns.each do |c|
            l.each do |word|
                r = clazz.find( :all, :conditions => ["#{c} LIKE ?", "%#{word}%"] )
                if res then
                    res = res + r
                else
                    res = r
                end
            end
        end
        if ( res ) then
            res = res.uniq
        end
        return res || []
    end


    def parts_needed( part, type=-1, cnt=1, make_new_part=true, level=1, max_level=10 )
        if ( level > max_level )
            return nil, nil
        end

        parts = {}
        complex_parts = {}

        # If make new part or just see if there are enough parts in stock.
        if ( not make_new_part )
            if ( part.has_subparts? )
                complex_parts[ part.id ] = cnt
            else
                parts[ part.id ] = cnt
            end
        end

        # Iterate over all subparts.
        sps = Subpart.where( belongs_id: part.id )
        sps.each do |sp|
            n = sp.cnt * cnt
            subpart = Part.find( sp.contains_id )
            # If part is complex add only subparts.
            if ( subpart.has_subparts? )
                #puts "#########"
                #puts "has_subparts #{sp.contains_id}"
                #puts "#########"
                complex_parts[ subpart.id ] = ( complex_parts[ subpart.id ] ) ? 
                                                ( complex_parts[ subpart.id ] + n)  : n
                subparts, complex_subparts = parts_needed( subpart, type, n, true, level+1, max_level )
                subparts.each do |sp_id, sp_cnt|
                    parts[ sp_id ] = ( parts[ sp_id ] ) ? 
                                            ( parts[ sp_id ] + sp_cnt ) : (sp_cnt || 0)
                end
                complex_subparts.each do |cp_id, cp_cnt|
                    complex_parts[ cp_id ] = ( complex_parts[ cp_id ] ) ? 
                                                    ( complex_parts[ cp_id ] + cp_cnt )  : cp_cnt
                end
            else
                #puts "#########"
                #puts "has_no_subparts #{sp.contains_id}"
                #puts "#########"
                # If part is simple just add itself.
                if ( type < 0 ) || ( type == sp.contains.part_type )
                    parts[ sp.contains_id ] = ( parts[ sp.contains_id ] ) ? 
                                                    ( parts[ sp.contains_id ] + n ) : n
                end
            end
        end
        return parts, complex_parts
    end

    def parts_missing( part, type, cnt )
        parts, complex_parts = parts_needed( part, type, cnt )
        
        exists = {}
        part_insts = PartInst.all
        part_insts.each do |pi|
            exists[ pi.part_id ] = ( exists[ pi.part_id ] ) ? 
                                        ( exists[ pi.part_id ] + pi.cnt ) : pi.cnt
        end
        # For each existing complex part subtract it's part amounts from needed amounts.
        improvements = 1
        while improvements > 0 do
            improvements = 0
            # Copy complex_parts_array.
            cps = {}
            complex_parts.each do |cp_id, cp_cnt|
                cps[ cp_id ] = cp_cnt
            end
            # Search among existing complex parts.
            cps.each do |cp_id, cp_cnt|
                if ( exists[ cp_id ] ) then
                    # Increase improvements.
                    improvements += 1

                    max_cnt = ( exists[ cp_id ] < cp_cnt ) ? exists[ cp_id ] : cp_cnt
                    # Remove appropriate 'max_cnt' from 'exists'
                    exists[ cp_id ] -= max_cnt
                    if ( exists[ cp_id ] <= 0 ) then
                        exists.delete( cp_id )
                    end
                    # Look for a part of this type.
                    c_part = Part.find( cp_id )
                    # Extract content
                    cp_parts, cp_complex_parts = parts_needed( c_part, max_cnt )
                    # Correct 'complex_parts' and 'parts'.
                    cp_complex_parts.each do |cp_id, cp_cnt|
                        complex_parts[ cp_id ] -= cp_cnt
                        if ( complex_parts[ cp_id ] <= 0 ) then
                            complex_parts.delete( cp_id )
                        end
                    end
                    cp_parts.each do |cp_id, cp_cnt|
                        parts[ cp_id ] ||= 0 # This is for the case if "parts" don't incude part with "id = cp_id" yet.
                        parts[ cp_id ] -= cp_cnt
                        if ( parts[ cp_id ] <= 0 ) then
                            parts.delete( cp_id )
                        end
                    end
                end
            end
        end

        # Search among existing simple parts.
        improvements = 1
        while improvements > 0 do
            improvements = 0
            # Make parts copy.
            ps = {}
            parts.each do |p_id, p_cnt|
                ps[ p_id ] = p_cnt
            end

            ps.each do |p_id, p_cnt|
                if ( exists[ p_id ] )
                    improvements += 1
                    max_cnt = ( exists[ p_id ] < p_cnt ) ? exists[ p_id ] : p_cnt
                    parts[ p_id ] -= max_cnt
                    if ( parts[ p_id ] <= 0 ) then
                        parts.delete( p_id )
                    end
                    exists[ p_id ] -= max_cnt
                    if ( exists[ p_id ] <= 0 ) then
                        exists.delete( p_id )
                    end
                end
            end
        end

        return parts, {}
    end

    def total_price( parts )
        pr = 0
        parts.each do |p_id, p_cnt|
            part = Part.find( p_id.to_i )
            unit_price = part.order_price ? part.order_price : 0
            pr += unit_price * p_cnt
        end
        return pr
    end

    def order_parts( parts )
        parts.each do |part_id, part_cnt|
            if not order_part( part_id, part_cnt ) then
                return false
            end
        end
        return true
    end

private
    def order_part( part_id, cnt )
        part = Part.find( part_id )
        item = Item.new
        item.set_sz      = 1
        item.sets_cnt    = cnt
        item.internal_id = part.own_id
        item.supplier_id = part.third_id
        item.unit_price  = part.order_price || 0
        item.desc        = part.order_desc || ""
        item.order_link  = part.order_link || ""
        item.image       = part.image

        item.user_placed  = @user.id
        item.user_resp    = params[ :user_resp ]
        item.contract_id  = params[ :contract_id ]
        item.deliver_addr = params[ :deliver_addr ]
        item.status       = params[ :status ]

        res = item.save
        return res
    end

end
