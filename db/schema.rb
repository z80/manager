# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141218064846) do

  create_table "attachment_to_contracts", force: true do |t|
    t.integer  "attachment_id"
    t.integer  "contract_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachment_to_parts", force: true do |t|
    t.integer  "attachment_id"
    t.integer  "part_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachment_to_prod_types", force: true do |t|
    t.integer  "attachment_id"
    t.integer  "prod_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachment_to_products", force: true do |t|
    t.integer  "attachment_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachment_to_subparts", force: true do |t|
    t.integer  "attachment_id"
    t.integer  "subpart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: true do |t|
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "boxes", force: true do |t|
    t.string   "box_id"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "warehouse_id"
  end

  create_table "contract_items", force: true do |t|
    t.integer  "contract_id"
    t.integer  "prod_type_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "superitem_id"
    t.integer  "shipment_id"
    t.string   "number"
    t.integer  "ship_date_id"
  end

  create_table "contracts", force: true do |t|
    t.string   "name"
    t.text     "desc"
    t.date     "ship_date"
    t.boolean  "shipped"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "warning"
    t.string   "number"
    t.integer  "owner_id"
    t.integer  "box_id"
  end

  create_table "image_to_parts", force: true do |t|
    t.integer  "image_id"
    t.integer  "part_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "image_to_samples", force: true do |t|
    t.integer  "image_id"
    t.integer  "sample_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "image_to_subparts", force: true do |t|
    t.integer  "image_id"
    t.integer  "subpart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text     "desc"
  end

  create_table "item_statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.string   "supplier_id"
    t.string   "internal_id"
    t.text     "desc"
    t.string   "order_link"
    t.string   "contract_desc"
    t.text     "deliver_addr"
    t.string   "status"
    t.integer  "user_placed_id"
    t.integer  "user_resp_id"
    t.integer  "set_sz"
    t.integer  "sets_cnt"
    t.decimal  "unit_price",         precision: 10, scale: 4
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "status_id"
    t.integer  "part_id"
    t.date     "order_date"
    t.integer  "contract_id"
  end

  create_table "logs", force: true do |t|
    t.text     "msg"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.text     "desc"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "part_insts", force: true do |t|
    t.integer  "part_id"
    t.integer  "box_id"
    t.integer  "cnt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "part_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parts", force: true do |t|
    t.string   "own_id"
    t.string   "third_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "desc"
    t.integer  "min_cnt"
    t.text     "order_link"
    t.text     "order_desc"
    t.decimal  "order_price",        precision: 10, scale: 4
    t.integer  "part_type"
    t.integer  "order_time"
    t.integer  "ordering_person_id"
  end

  create_table "prod_subtypes", force: true do |t|
    t.integer  "belongs_id"
    t.integer  "contains_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prod_types", force: true do |t|
    t.integer  "part_id"
    t.string   "own_id"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "user_id"
    t.text     "packing_details"
    t.boolean  "client_visible"
    t.text     "pack_to"
  end

  create_table "product_statuses", force: true do |t|
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "avail"
  end

  create_table "products", force: true do |t|
    t.integer  "prod_type_id"
    t.string   "serial_number"
    t.text     "desc"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "box_id"
    t.integer  "owner_id"
  end

  create_table "samples", force: true do |t|
    t.text     "from"
    t.text     "desc"
    t.datetime "received"
    t.datetime "due"
    t.integer  "user_placed"
    t.integer  "user_resp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "location"
    t.integer  "status"
    t.integer  "warn_days"
    t.integer  "box_id"
  end

  create_table "ship_dates", force: true do |t|
    t.integer  "contract_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shipments", force: true do |t|
    t.integer  "contract_id"
    t.string   "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subparts", force: true do |t|
    t.integer  "contains_id"
    t.integer  "belongs_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cnt"
  end

  create_table "tests", force: true do |t|
    t.string   "msg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "surname"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", unique: true

  create_table "warehouses", force: true do |t|
    t.string   "w_id"
    t.text     "w_desc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

end
