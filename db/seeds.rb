# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#u = User.new
#u.email   = 'admin@admin.com'
#u.name    = 'Admin'
#u.surname = ''
#u.password = '12345'
#u.password_confirmation = '12345'
#u.admin = true
#u.save!

if ( PartType.all.size < 1 )
  t = PartType.new
  t.name = 'Purchasable USA'
  t.save!

  t = PartType.new
  t.name = 'Purchasable Russia'
  t.save!

  t = PartType.new
  t.name = 'Purchasable Netherlands'
  t.save!

  t = PartType.new
  t.name = 'Orderable USA'
  t.save!

  t = PartType.new
  t.name = 'Orderable Russia'
  t.save!

  t = PartType.new
  t.name = 'Orderable China'
  t.save!

  t = PartType.new
  t.name = 'Assembly USA'
  t.save!

  t = PartType.new
  t.name = 'Assembly Russia'
  t.save!
end


if ( ItemStatus.all.size < 1 )
  s = ItemStatus.new
  s.name = 'To be ordered'
  s.save!

  s = ItemStatus.new
  s.name = 'Ordered'
  s.save!

  s = ItemStatus.new
  s.name = 'Delivered'
  s.save!

  s = ItemStatus.new
  s.name = 'Complete'
  s.save!
end

if ( ProductStatus.all.size < 1 )
  s = ProductStatus.new
  s.status = "In stock"
  s.avail  = true
  s.save!

  s = ProductStatus.new
  s.status = "In repair"
  s.avail  = true
  s.save!

  s = ProductStatus.new
  s.status = "At client\'s site"
  s.avail  = false
  s.save!

  s = ProductStatus.new
  s.status = "Disassembled"
  s.avail  = false
  s.save!
end









