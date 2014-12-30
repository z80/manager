# == Schema Information
#
# Table name: ship_dates
#
#  id          :integer          not null, primary key
#  contract_id :integer
#  date        :date
#  created_at  :datetime
#  updated_at  :datetime
#

class ShipDate < ActiveRecord::Base
  attr_accessible :contract_id
  attr_accessible :date

  def contract
    ci = Contract.exists?( self.contract_id )
    if not ci
      return nil
    end
    ci = Contract.find( self.contract_id )
    return ci
  end
end
