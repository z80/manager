# == Schema Information
#
# Table name: shipments
#
#  id          :integer          not null, primary key
#  contract_id :integer
#  desc        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Shipment < ActiveRecord::Base
  attr_accessible :contract_id
  attr_accessible :desc

  def contract_items
    ci = ContractItem.where( shipment_id: self.id )
    return ci
  end
end
