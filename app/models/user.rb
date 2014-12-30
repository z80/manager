# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  email               :string(255)
#  name                :string(255)
#  surname             :string(255)
#  password_digest     :string(255)
#  remember_token      :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  admin               :boolean
#


require "securerandom"

class User < ActiveRecord::Base
  include SecureRandom


  has_attached_file :avatar, 
                    :styles => { :thumb => "128x128>", :big => "512x512>" }, 
                    :default_url => "/images/:style/missing.png"
  validates_attachment :avatar, 
                       :size =>{ :in => 0..256.kilobytes }


  has_secure_password
  has_many        :orders 
  has_many        :parts
  has_many        :part_insts
  has_many        :boxes
  attr_accessible :email, 
                  :name, 
                  :surname, 
                  :password, 
                  :password_confirmation, 
                  :admin

  VALID_EMAIL_REGEX = /\A[\w\d\.-]+@[\w\d\.-]+\.\w{1,3}\z/i
  validates       :email, 
                  presence: true, 
                  format: { with: VALID_EMAIL_REGEX }#, 
                  #uniqueness: { case_sensitive: false }

  validates       :password, 
                  presence: true, 
                  length: { minimum: 4 }

  validates       :password_confirmation, 
                  presence: true


  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  before_create :make_admin_field_valid

  def admin?
    if ( !self.admin )
      self.admin=( false )
    end
    return self.admin
  end

  #def email
  #  @email
  #end

  #def email=( arg )
  #  @email = arg.downcase
  #end

  def ver
    return "ver a"
  end

  def name_stri
    return self.name.to_s + ' ' + self.surname.to_s
  end

private

  def create_remember_token
    #require 'securerandom'
    self.remember_token = SecureRandom.urlsafe_base64 + SecureRandom.urlsafe_base64
  end

  def make_admin_field_valid
    #debugger
    if ( self.admin == nil )
      self.admin = false
    end
  end
end





