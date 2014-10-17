# == Schema Information
#
# Table name: attachments
#
#  id                :integer          not null, primary key
#  desc              :text
#  created_at        :datetime
#  updated_at        :datetime
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#

class Attachment < ActiveRecord::Base
  attr_accessible :desc
  attr_accessible :file

  has_attached_file    :file
  validates_attachment :file,  :size => { :in => 0..10.megabytes },
                               :url => "/assets/files/:id/:style/:basename.:extension",
                               :path => ":rails_root/public/assets/items/:id/:style/:basename.:extension"
end
