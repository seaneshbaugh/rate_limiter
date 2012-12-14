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

ActiveRecord::Schema.define(:version => 20121213101512) do

  create_table "messages", :force => true do |t|
    t.string   "first_name", :default => "", :null => false
    t.string   "last_name",  :default => "", :null => false
    t.string   "subject",    :default => "", :null => false
    t.text     "body",       :default => "", :null => false
    t.string   "ip_address", :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "messages", ["created_at"], :name => "index_messages_on_created_at"
  add_index "messages", ["first_name"], :name => "index_messages_on_first_name"
  add_index "messages", ["ip_address"], :name => "index_messages_on_ip_address"
  add_index "messages", ["last_name"], :name => "index_messages_on_last_name"
  add_index "messages", ["subject"], :name => "index_messages_on_subject"
  add_index "messages", ["updated_at"], :name => "index_messages_on_updated_at"

end
