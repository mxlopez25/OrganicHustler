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

ActiveRecord::Schema.define(version: 20170512062246) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  end

  create_table "cart_products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "m_id"
    t.string "logo_id"
    t.decimal "dim_x", precision: 10
    t.decimal "dim_y", precision: 10
    t.decimal "relation_x", precision: 10
    t.decimal "relation_y", precision: 10
    t.decimal "width", precision: 10
    t.decimal "height", precision: 10
    t.boolean "has_logo"
    t.boolean "has_emblem"
    t.string "emblem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position_id"
    t.integer "cart_id"
    t.string "size_id"
  end

  create_table "carts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.boolean "is_active"
    t.integer "n_products", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "overall_user_id"
    t.string "overall_user_type", limit: 45, default: "TempUser", collation: "utf8_general_ci"
    t.string "order_id"
  end

  create_table "emblems", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture_file_name"
    t.string "picture_content_type"
    t.integer "picture_file_size"
    t.datetime "picture_updated_at"
    t.decimal "pos_1_x", precision: 10
    t.decimal "pos_1_y", precision: 10
    t.decimal "pos_2_x", precision: 10
    t.decimal "pos_2_y", precision: 10
    t.decimal "pos_3_x", precision: 10
    t.decimal "pos_3_y", precision: 10
    t.decimal "pos_4_x", precision: 10
    t.decimal "pos_4_y", precision: 10
    t.decimal "emblem_cost", precision: 10
    t.decimal "width", precision: 10
    t.decimal "height", precision: 10
    t.decimal "rel_x", precision: 10
    t.decimal "rel_y", precision: 10
    t.string "id_moltin"
  end

  create_table "galleries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name",       default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string "product_id"
  end

  create_table "group_showcases", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.text "name_identity", limit: 65535
    t.integer "screen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_count"
  end

  create_table "image_shows", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.integer "showcase_id"
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "state"
    t.text "description", limit: 65535
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "carrier"
    t.string "tracking_code"
    t.string "overall_user_id"
    t.string "overall_user_type"
    t.string "charge_id"
    t.string "tag_link"
    t.string "user_address_id"
  end

  create_table "pictures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "gallery_id"
    t.string   "color"
    t.string "type"
    t.decimal "price", precision: 10
  end

  create_table "promotion_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.decimal "rate", precision: 10
    t.string "code"
    t.datetime "timeAv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_id"
  end

  create_table "relation_logos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "item_id",                  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.float    "left_margin",   limit: 24
    t.float    "top_margin",    limit: 24
    t.float    "right_margin",  limit: 24
    t.float    "bottom_margin", limit: 24
  end

  create_table "showcases", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "screen"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "video_show_id"
    t.integer "image_show_id"
    t.string "product_id"
    t.string "url_association"
    t.integer "group_showcase_id"
  end

  create_table "subscribers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "temp_user_controls", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "auth_token"
    t.datetime "t_available"
    t.string "temp_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ip_address"
    t.boolean "valid_token"
  end

  create_table "temp_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "user_id"
    t.string "street_address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "area"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_id"
    t.string "overall_user_id"
    t.string "overall_user_type"
    t.string "name"
    t.string "last_name"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "user_name",              default: "", null: false
    t.string   "user_last_name",         default: "", null: false
    t.string   "id_moltin"
    t.string "c_stripe_id"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "video_shows", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "video_file_name"
    t.string "video_content_type"
    t.integer "video_file_size"
    t.datetime "video_updated_at"
    t.integer "showcase_id"
  end

end
