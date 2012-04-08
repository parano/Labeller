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

ActiveRecord::Schema.define(:version => 20120312132140) do

  create_table "labeljobs", :force => true do |t|
    t.string   "name"
    t.text     "desc"
    t.date     "deadline"
    t.string   "labels"
    t.integer  "user_id"
    t.boolean  "finished",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "rawdata"
    t.string   "filter"
  end

  add_index "labeljobs", ["user_id", "created_at"], :name => "index_labeljobs_on_user_id_and_created_at"

  create_table "labeljobs_users", :id => false, :force => true do |t|
    t.integer "labeljob_id"
    t.integer "user_id"
  end

  add_index "labeljobs_users", ["labeljob_id", "user_id"], :name => "index_labeljobs_users_on_labeljob_id_and_user_id", :unique => true
  add_index "labeljobs_users", ["labeljob_id"], :name => "index_labeljobs_users_on_labeljob_id"
  add_index "labeljobs_users", ["user_id"], :name => "index_labeljobs_users_on_user_id"

  create_table "labeltasks", :force => true do |t|
    t.string   "status"
    t.integer  "labeljob_id"
    t.integer  "user_id"
    t.integer  "label_count"
    t.integer  "unlabel_count"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "labeltasks", ["labeljob_id", "user_id"], :name => "index_labeltasks_on_labeljob_id_and_user_id"

  create_table "solutions", :force => true do |t|
    t.integer  "labeltask_id"
    t.integer  "line_number"
    t.string   "label"
    t.text     "rawdata"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "solutions", ["labeltask_id", "line_number"], :name => "index_solutions_on_labeltask_id_and_line_number", :unique => true
  add_index "solutions", ["labeltask_id"], :name => "index_solutions_on_labeltask_id"
  add_index "solutions", ["line_number"], :name => "index_solutions_on_line_number"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "role"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
