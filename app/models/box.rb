# == Schema Information
#
# Table name: boxes
#
#  id           :integer          not null, primary key
#  box_id       :string(255)
#  desc         :text
#  created_at   :datetime
#  updated_at   :datetime
#  warehouse_id :integer
#

class Box < ActiveRecord::Base
  belongs_to :user
  belongs_to :warehouse
  has_many   :part_insts

  attr_accessible :box_id
  attr_accessible :desc
  attr_accessible :warehouse_id

  def products()
  	prods = Product.where( box_id: self.id )
  	return prods
  end

  def samples()
    samps = Sample.where( box_id: self.id )
    return samps
  end

  def warehouse()
  	wh = Warehouse.exists?( self.warehouse_id )
  	if ( not wh )
  		return nil
  	end
  	wh = Warehouse.find( self.warehouse_id )
  end
end
