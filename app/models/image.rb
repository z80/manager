# == Schema Information
#
# Table name: images
#
#  id                  :integer          not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  desc                :text
#

class Image < ActiveRecord::Base

  attr_accessible :desc

  has_attached_file :avatar, :styles => { :medium => "512x512>", :thumb => "128x128>" }, :default_url => "/images/:style/missing.png"
  validates_attachment :avatar, #:presence => true,  
                                #:content_type => { :content_type => ["image/jpg", "image/gif", "image/png"] },
                                :size => { :in => 0..512.kilobytes }, 
                                :path => ":rails_root/public/images/avatars/:id/:style_:basename.:extension", 
                                :url => "/app/assets/images/article_images/:id/:style_:basename.:extension"                                


end
