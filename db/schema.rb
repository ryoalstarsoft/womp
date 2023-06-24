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

ActiveRecord::Schema.define(version: 2018_12_13_195515) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "receive_emails", default: true
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "annotations", force: :cascade do |t|
    t.integer "upload_id"
    t.decimal "x"
    t.decimal "y"
    t.decimal "width"
    t.decimal "height"
    t.string "annotation_type"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.index ["upload_id"], name: "index_annotations_on_upload_id"
  end

  create_table "authentications", force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "carts", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "comment_uploads", force: :cascade do |t|
    t.integer "comment_id"
    t.integer "upload_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_comment_uploads_on_comment_id"
    t.index ["upload_id"], name: "index_comment_uploads_on_upload_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "admin_user_id"
    t.integer "project_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "viewed", default: false
    t.integer "projectable_id"
    t.string "projectable_type"
    t.index ["admin_user_id"], name: "index_comments_on_admin_user_id"
    t.index ["project_id"], name: "index_comments_on_project_id"
    t.index ["projectable_id", "projectable_type"], name: "index_comments_on_projectable_id_and_projectable_type"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "material_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materials", force: :cascade do |t|
    t.string "provider"
    t.string "name"
    t.string "texture"
    t.string "finish"
    t.boolean "direct_print"
    t.string "resolution"
    t.decimal "min_x"
    t.decimal "min_y"
    t.decimal "min_z"
    t.decimal "max_x"
    t.decimal "max_y"
    t.decimal "max_z"
    t.string "technology"
    t.decimal "volume_price", default: "0.0"
    t.decimal "machine_space_price", default: "0.0"
    t.decimal "bounding_box_price", default: "0.0"
    t.decimal "surface_area_price", default: "0.0"
    t.decimal "handling_price", default: "0.0"
    t.decimal "support_price", default: "0.0"
    t.string "preview_image_url"
    t.string "model_image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "spreadsheet_identifier"
    t.string "material_category"
    t.integer "roll_inventory"
    t.string "material_type"
    t.string "resin_finish"
    t.string "color", default: [], array: true
    t.integer "days_to_print"
    t.integer "cost_level"
    t.string "material_spec"
    t.boolean "skin_friendly"
    t.boolean "interlocking"
    t.boolean "water_tight"
    t.boolean "chemical_resistant"
    t.string "heat_proof"
    t.boolean "dishwasher_safe"
    t.boolean "food_safe"
    t.string "min_size"
    t.string "max_size"
    t.decimal "min_wall_supported"
    t.decimal "min_wall_unsupported"
    t.decimal "min_wire_supported"
    t.decimal "min_wire_unsupported"
    t.decimal "min_detail_concave"
    t.decimal "min_detail_convex"
    t.integer "escape_hole_single"
    t.integer "escape_hole_multiple"
    t.decimal "clearance"
    t.decimal "per_part_price"
    t.string "uses", default: [], array: true
    t.string "pros", default: [], array: true
    t.string "cons", default: [], array: true
    t.boolean "archived", default: false
  end

  create_table "modeling_projects", force: :cascade do |t|
    t.integer "user_id"
    t.integer "cart_id"
    t.integer "order_id"
    t.integer "workspace_id"
    t.string "name"
    t.string "slug"
    t.string "status"
    t.boolean "paid", default: false
    t.datetime "paid_at"
    t.decimal "final_price"
    t.text "description"
    t.boolean "user_captioned", default: false
    t.boolean "user_reviewed", default: false
    t.boolean "womp_reviewed", default: false
    t.string "pricing_group"
    t.decimal "price_override"
    t.integer "previous_version_modeling_project_id"
    t.string "modeler_password"
    t.datetime "modeler_deadline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "previous_project_slug"
    t.index ["cart_id"], name: "index_modeling_projects_on_cart_id"
    t.index ["order_id"], name: "index_modeling_projects_on_order_id"
    t.index ["previous_version_modeling_project_id"], name: "index_modeling_projects_on_previous_version_modeling_project_id"
    t.index ["user_id"], name: "index_modeling_projects_on_user_id"
    t.index ["workspace_id"], name: "index_modeling_projects_on_workspace_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "printing_projects", force: :cascade do |t|
    t.integer "user_id"
    t.integer "cart_id"
    t.integer "order_id"
    t.integer "workspace_id"
    t.integer "material_id"
    t.string "name"
    t.string "slug"
    t.string "status"
    t.boolean "paid", default: false
    t.datetime "paid_at"
    t.decimal "final_price"
    t.decimal "final_tax"
    t.boolean "womp_approved", default: false
    t.decimal "price_override"
    t.string "tracking_number"
    t.string "carrier"
    t.boolean "picked_up"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", default: 1
    t.index ["cart_id"], name: "index_printing_projects_on_cart_id"
    t.index ["material_id"], name: "index_printing_projects_on_material_id"
    t.index ["order_id"], name: "index_printing_projects_on_order_id"
    t.index ["user_id"], name: "index_printing_projects_on_user_id"
    t.index ["workspace_id"], name: "index_printing_projects_on_workspace_id"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "user_id"
    t.string "project_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "quotes", force: :cascade do |t|
    t.string "quote_type"
    t.string "object_size"
    t.string "model_type"
    t.decimal "object_height"
    t.decimal "object_width"
    t.decimal "object_depth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "object_most_like"
    t.string "hollow_or_solid"
    t.decimal "wall_thickness"
    t.integer "material_id"
    t.decimal "printing_price"
    t.index ["material_id"], name: "index_quotes_on_material_id"
  end

  create_table "scanning_projects", force: :cascade do |t|
    t.integer "user_id"
    t.integer "cart_id"
    t.integer "order_id"
    t.integer "workspace_id"
    t.string "slug"
    t.string "name"
    t.string "status"
    t.boolean "paid", default: false
    t.datetime "paid_at"
    t.decimal "final_price"
    t.string "object_size"
    t.string "resolution"
    t.string "color"
    t.decimal "length"
    t.decimal "width"
    t.decimal "height"
    t.boolean "user_reviewed", default: false
    t.decimal "price_override"
    t.boolean "womp_received", default: false
    t.datetime "received_at"
    t.string "tracking_number"
    t.string "carrier"
    t.boolean "picked_up", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_scanning_projects_on_cart_id"
    t.index ["order_id"], name: "index_scanning_projects_on_order_id"
    t.index ["user_id"], name: "index_scanning_projects_on_user_id"
    t.index ["workspace_id"], name: "index_scanning_projects_on_workspace_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.integer "project_id"
    t.string "link"
    t.string "original_filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sketchfab_uid"
    t.string "imaterialise_id"
    t.integer "user_id"
    t.integer "admin_user_id"
    t.boolean "accepted"
    t.decimal "volume"
    t.decimal "surface_area"
    t.decimal "bounding_box_volume"
    t.decimal "bounding_box_x"
    t.decimal "bounding_box_y"
    t.decimal "bounding_box_z"
    t.decimal "machine_space"
    t.string "drc_link"
    t.text "description"
    t.boolean "reviewable", default: false
    t.string "nxs_link"
    t.boolean "smoothing", default: true
    t.boolean "released_to_user", default: false
    t.boolean "modeler_can_see", default: false
    t.integer "projectable_id"
    t.string "projectable_type"
    t.index ["admin_user_id"], name: "index_uploads_on_admin_user_id"
    t.index ["project_id"], name: "index_uploads_on_project_id"
    t.index ["projectable_id", "projectable_type"], name: "index_uploads_on_projectable_id_and_projectable_type"
    t.index ["user_id"], name: "index_uploads_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address_line_one"
    t.string "address_line_two"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "country"
    t.string "stripe_customer_identifier"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workspaces", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
