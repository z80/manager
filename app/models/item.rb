# == Schema Information
#
# Table name: items
#
#  id                 :integer          not null, primary key
#  supplier_id        :string(255)
#  internal_id        :string(255)
#  desc               :text
#  order_link         :string(255)
#  contract_id        :string(255)
#  deliver_addr       :text
#  status             :string(255)
#  user_placed        :integer
#  user_resp          :integer
#  set_sz             :integer
#  sets_cnt           :integer
#  unit_price         :decimal(10, 4)
#  comment            :text
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  status_i           :integer
#  part_id            :integer
#

class Item < ActiveRecord::Base
  has_attached_file    :image, :styles => { :medium => "512x512>", :thumb => "128x128>" }, :default_url => "/images/:style/missing.png"
  validates_attachment :image, #:presence => true,  
                               #:content_type => { :content_type => ["image/jpg", "image/gif", "image/png"] },
                               :size => { :in => 0..256.kilobytes }, 
                               :path => ":rails_root/public/images/avatars/:id/:style_:basename.:extension", 
                               :url => "/app/assets/images/article_images/:id/:style_:basename.:extension"

  attr_accessible :supplier_id
  attr_accessible :internal_id
  attr_accessible :desc
  attr_accessible :order_link
  attr_accessible :contract_id
  attr_accessible :deliver_addr
  attr_accessible :status
  attr_accessible :user_placed
  attr_accessible :user_resp
  attr_accessible :set_sz
  attr_accessible :sets_cnt
  attr_accessible :unit_price
  attr_accessible :comment
  attr_accessible :status_i
  attr_accessible :part_id

  def user_resp_name
    if ( not User.exists?( self.user_resp ) ) then
      return "unspecified"
    end
    user = User.find( self.user_resp )
    name = user.name + ' ' + user.surname
    return name
  end

  def user_placed_name
    if ( not User.exists?( self.user_placed ) ) then
      return "unspecified"
    end
    user = User.find( self.user_placed )
    name = user.name + ' ' + user.surname
    return name
  end

  def total_price
    return ( self.unit_price && self.set_sz && self.sets_cnt ) ? (
                self.unit_price * self.set_sz * self.sets_cnt ) : "Can\'t be calculated"
  end

  def status_name
    t = self.status_i
    if ( ItemStatus.exists?( t ) )
      name = ItemStatus.find( t ).name
      return name
    elsif ( t.class == :Fixnum )
      name = "Completed"
    end
    return 'Unspecified'
  end

  def cnt
    return self.set_sz * self.sets_cnt
  end

  def part
    if Part.exists?( self.part_id )
      res = Part.find( self.part_id )
      return res
    end
    return nil
  end

  def image_ex
    if ( self.image )
      return self.image
    end
    p = part()
    return p.image if ( p )
    return nil
  end
end
