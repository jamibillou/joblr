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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130103145034) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "uname"
    t.string   "uemail"
    t.string   "url"
    t.string   "utoken"
    t.string   "usecret"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "emails", :force => true do |t|
    t.integer  "recipient_id"
    t.string   "code"
    t.string   "recipient_email"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "sent",               :default => false
    t.string   "author_fullname"
    t.string   "author_email"
    t.string   "recipient_fullname"
    t.string   "cc"
    t.string   "bcc"
    t.string   "reply_to"
    t.string   "subject"
    t.string   "status"
    t.string   "type"
    t.string   "page"
    t.string   "text"
    t.boolean  "used",               :default => false
    t.integer  "profile_id"
    t.integer  "author_id"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "experience"
    t.string   "last_job"
    t.string   "past_companies"
    t.string   "education"
    t.string   "skill_1"
    t.string   "skill_1_level"
    t.string   "skill_2"
    t.string   "skill_2_level"
    t.string   "skill_3"
    t.string   "skill_3_level"
    t.string   "quality_1"
    t.string   "quality_2"
    t.string   "quality_3"
    t.string   "file"
    t.string   "url"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "linkedin_url"
    t.string   "twitter_url"
    t.string   "facebook_url"
    t.string   "google_url"
  end

  create_table "users", :force => true do |t|
    t.string   "fullname"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
    t.string   "image"
    t.string   "city"
    t.string   "country"
    t.string   "subdomain"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
    t.boolean  "social",                 :default => false
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
