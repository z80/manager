# == Schema Information
#
# Table name: prod_types
#
#  id                 :integer          not null, primary key
#  part_id            :integer
#  own_id             :string(255)
#  desc               :text
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  user_id            :integer
#

class ProdType < ActiveRecord::Base
  include PartsHelper

  attr_accessible :part_id
  attr_accessible :own_id
  attr_accessible :desc
  attr_accessible :user_id
  attr_accessible :image

  has_attached_file :image, :styles => { :medium => "512x512>", :thumb => "128x128>" }, :default_url => "/images/:style/missing.png"
  validates_attachment :image, #:presence => true,  
                               #:content_type => { :content_type => ["image/jpg", "image/gif", "image/png"] },
                               :size => { :in => 0..512.kilobytes }, 
                               :path => ":rails_root/public/images/avatars/:id/:style_:basename.:extension", 
                               :url => "/app/assets/images/article_images/:id/:style_:basename.:extension"

  def part()
    if ( not Part.exists?( self.part_id ) )
      return nil
    end
    part = Part.find( self.part_id )
    return part
  end
  
  # 'part_own_id', 'part_third_id', 'part_desc'
  def part_own_id()
  	if ( not Part.exists?( self.part_id ) )
  	  return nil
  	end
  	part = Part.find( self.part_id )
  	return part.own_id
  end

  def part_third_id()
  	if ( not Part.exists?( self.part_id ) )
  	  return nil
  	end
  	part = Part.find( self.part_id )
  	return part.third_id
  end

  def part_desc()
  	if ( not Part.exists?( self.part_id ) )
  	  return nil
  	end
  	part = Part.find( self.part_id )
  	return part.desc
  end

  def image_ex()
  	if self.image?
  	  return self.image
  	end
  	if ( not Part.exists?( self.part_id ) )
  	  return self.image # It will be missing image.
  	end
  	part = Part.find( self.part_id )
  	return part.image
  end

  def user_name()
  	if ( not User.exists?( self.user_id ) )
  	  return "Unspecified"
  	end
  	user = User.find( self.user_id )
  	name = user.name + " " + user.surname
  	return name
  end

  def products( only_avail, search, page )
    if ( search ) then
      paginate = false
      pp = search( Product, search, [ 'serial_number', 'desc' ] )
      if ( only_avail )
      	prods = []
      	pp.each do |prod|
      	  prods.append( prod ) if ( prod.avail? && (prod.prod_type_id == self.id) )
      	end
      else
        pp.each do |prod|
          prods.append( prod ) if (prod.prod_type_id == self.id)
        end
      end
    else
      paginate = true
      if ( only_avail )
      	statuses = ProductStatus.where( avail: true )
      	st = []
      	statuses.each do |a|
      	  st.append( a.id ) if ( a.avail? )
      	end
      	prods = Product.where( prod_type_id: self.id ).where( status: st ).order( "id desc" ).page( page )
      else
      	prods = Product.order( "id DESC" ).where( prod_type_id: self.id ).page( page )
      end
    end
  	return prods, paginate
  end

  def cnt()
  	prods = Product.where( prod_type_id: self.id )
    in_stock = 0
  	prods.each do |product|
      in_stock += 1 if product.avail?
    end
  	return in_stock
  end

  def cnt_for_import()
    if ( not  Part.exists?( self.part_id ) )
      return 0
    end
    part = Part.find( self.part_id )
    return part.cnt
  end

  def subproducts()
    psts = ProdSubtype.where( belongs_id: self.id )
    prods = []
    psts.each do |pst|
      pt = ProdType.find( pst.contains_id )
      prods.append( {subtype: pst, type: pt} )

      subprods = pt.subproducts()
      subprods.each do |a|
      	prods.append( {subtype: a[:subtype], type: a[:type]} )
      end
    end
    return prods
  end

  def contracts()
    cis = ContractItem.where( prod_type_id: self.id )
    res = {}
    cis.each do |ci|
      c = Contract.find( ci.contract_id )
      if ( not c.shipped )
        res[ c ] = ( res[c] ) ? ( res[c] + 1 ) : 1;
      end
    end
    return res
  end

  def valid_product?()
    if ( ( self.part() ) || ( self.subproducts.size > 0) )
      return true
    end
    return false
  end

end




