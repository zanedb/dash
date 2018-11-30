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

ActiveRecord::Schema.define(version: 2018_11_30_065706) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendee_field_values", force: :cascade do |t|
    t.text "content"
    t.bigint "attendee_field_id"
    t.bigint "attendee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendee_field_id"], name: "index_attendee_field_values_on_attendee_field_id"
    t.index ["attendee_id"], name: "index_attendee_field_values_on_attendee_id"
  end

  create_table "attendee_fields", force: :cascade do |t|
    t.bigint "event_id"
    t.string "name"
    t.string "label"
    t.string "kind"
    t.text "options", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_attendee_fields_on_event_id"
  end

  create_table "attendees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.text "note"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "checked_in_at"
    t.bigint "checked_in_by_id"
    t.index ["checked_in_by_id"], name: "index_attendees_on_checked_in_by_id"
    t.index ["event_id"], name: "index_attendees_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "slug"
    t.string "permitted_domains"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "hardware_items", force: :cascade do |t|
    t.string "checked_out_to"
    t.datetime "checked_out_at"
    t.bigint "checked_out_by_id"
    t.bigint "hardware_id"
    t.string "barcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "checked_in_at"
    t.bigint "checked_in_by_id"
    t.index ["barcode"], name: "index_hardware_items_on_barcode", unique: true
    t.index ["checked_in_by_id"], name: "index_hardware_items_on_checked_in_by_id"
    t.index ["checked_out_by_id"], name: "index_hardware_items_on_checked_out_by_id"
    t.index ["hardware_id"], name: "index_hardware_items_on_hardware_id"
  end

  create_table "hardwares", force: :cascade do |t|
    t.string "vendor"
    t.string "model"
    t.integer "quantity"
    t.string "slug"
    t.bigint "event_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_hardwares_on_event_id"
    t.index ["user_id"], name: "index_hardwares_on_user_id"
  end

  create_table "organizer_position_invites", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "user_id"
    t.bigint "organizer_position_id"
    t.bigint "sender_id"
    t.text "email"
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invite_url"
    t.index ["event_id", "email", "user_id"], name: "index_organizer_position_invites_uniqueness", unique: true
    t.index ["event_id"], name: "index_organizer_position_invites_on_event_id"
    t.index ["organizer_position_id"], name: "index_organizer_position_invites_on_organizer_position_id"
    t.index ["sender_id"], name: "index_organizer_position_invites_on_sender_id"
    t.index ["user_id"], name: "index_organizer_position_invites_on_user_id"
  end

  create_table "organizer_positions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_organizer_positions_on_event_id"
    t.index ["user_id"], name: "index_organizer_positions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.text "name", default: ""
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "admin_at"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attendee_field_values", "attendee_fields"
  add_foreign_key "attendee_field_values", "attendees"
  add_foreign_key "attendees", "events"
  add_foreign_key "attendees", "users", column: "checked_in_by_id"
  add_foreign_key "hardware_items", "hardwares"
  add_foreign_key "hardware_items", "users", column: "checked_in_by_id"
  add_foreign_key "hardware_items", "users", column: "checked_out_by_id"
  add_foreign_key "hardwares", "events"
  add_foreign_key "hardwares", "users"
  add_foreign_key "organizer_position_invites", "events"
  add_foreign_key "organizer_position_invites", "organizer_positions"
  add_foreign_key "organizer_position_invites", "users"
  add_foreign_key "organizer_position_invites", "users", column: "sender_id"
  add_foreign_key "organizer_positions", "events"
  add_foreign_key "organizer_positions", "users"
end
