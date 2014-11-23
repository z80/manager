# == Schema Information
#
# Table name: samples
#
#  id          :integer          not null, primary key
#  from        :text
#  desc        :text
#  received    :datetime
#  due         :datetime
#  user_placed :integer
#  user_resp   :integer
#  created_at  :datetime
#  updated_at  :datetime
#  location    :text
#  status      :integer
#  warn_days   :integer
#  box_id      :integer
#

class Sample < ActiveRecord::Base
  attr_accessible :from
  attr_accessible :desc
  attr_accessible :received
  attr_accessible :due
  attr_accessible :user_placed
  attr_accessible :user_resp
  attr_accessible :location
  attr_accessible :status
  attr_accessible :warn_days
  attr_accessible :box_id


  def add_image( image, desc )
    img = Image.new
    img.avatar = image
    img.desc   = desc
    if not img.save then
      return nil
    end

    img2sam = ImageToSample.new
    img2sam.image_id  = img.id
    img2sam.sample_id = self.id
    if ( not img2sam.save ) then
      return nil
    end

    return img
  end


  def images()
    img2sams = ImageToSample.where( sample_id: self.id )
    images = []
    img2sams.each do|img2sam|
      if ( Image.exists?( img2sam.image_id ) ) then
        images.append( Image.find( img2sam.image_id ) )
      end
    end
    return images
  end

  def user_placed_name()
    if ( User.exists?( self.user_placed ) )
      user = User.find( self.user_placed )
      name = user.name + ' ' + user.surname
      return name
    end
    return 'unspecified'
  end

  def user_resp_name()
    if ( User.exists?( self.user_resp ) )
      user = User.find( self.user_resp )
      name = user.name + ' ' + user.surname
      return name
    end
    return 'unspecified'
  end

  @@STATUS_PENDING    = 0
  @@STATUS_IN_MEASURE = 1
  @@STATUS_COMPLETED  = 2
  
  @@DEFAULT_WARN_DAYS = 7

  def Sample.status_list()
    res = {}
    res[ @@STATUS_PENDING ]    = "pending"
    res[ @@STATUS_IN_MEASURE ] = "in measure"
    res[ @@STATUS_COMPLETED ]  = "completed"
    return res
  end

  def status_stri()
    st = self.status || @@STATUS_PENDING
    return Sample.status_list()[ st ]
  end

  # Status completed?
  def completed?()
    return (self.status == @@STATUS_COMPLETED)
  end

  def still_valid?()
    if completed?() then
      return true
    end
    warn_days = (self.warn_days || @@DEFAULT_WARN_DAYS).to_f
    due_time  = self.due
    now_time  = Time.now
    left_days = (due_time - now_time).to_f / (24*60*60).to_f
    return (left_days > warn_days)
  end

  def box()
    res = Box.exists?( self.box_id )
    if ( not res )
      return nil
    end
    res = Box.find( self.box_id )
    return res
  end

end






