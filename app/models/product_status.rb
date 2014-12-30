# == Schema Information
#
# Table name: product_statuses
#
#  id         :integer          not null, primary key
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  avail      :boolean
#

class ProductStatus < ActiveRecord::Base
  attr_accessible :status
  attr_accessible :avail


  def for_sale?
    if ( self.status == "In stock" ) || ( self.status == "In the office" )
      return true
    end
    return false
  end

  def self.status_in_stock
    s = ProductStatus.find_by_status( "In stock" )
    if ( s )
      return s.id
    end
    return nil
  end

  def self.status_in_office
    s = ProductStatus.find_by_status( "In the office" )
    if ( s )
      return s.id
    end
    return nil
  end

  def self.status_at_clients_site
    s = ProductStatus.find_by_status( "At client\'s site" )
    if ( s )
      return s.id
    end
    return nil
  end

end
