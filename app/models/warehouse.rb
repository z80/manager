# == Schema Information
#
# Table name: warehouses
#
#  id                 :integer          not null, primary key
#  w_id               :string(255)
#  w_desc             :text
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Warehouse < ActiveRecord::Base
  has_attached_file    :image, :styles => { :medium => "512x512>", :thumb => "128x128>" }, :default_url => "/images/:style/missing.png"
  validates_attachment :image, #:presence => true,  
                               #:content_type => { :content_type => ["image/jpg", "image/gif", "image/png"] },
                               :size => { :in => 0..256.kilobytes }, 
                               :path => ":rails_root/public/images/avatars/:id/:style_:basename.:extension", 
                               :url  => "/app/assets/images/article_images/:id/:style_:basename.:extension"
  attr_accessible :w_id
  attr_accessible :w_desc

  has_many :boxes
end
