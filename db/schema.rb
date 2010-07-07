# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100630145500) do

  create_table "bills", :force => true do |t|
    t.string   "name",                             :null => false
    t.integer  "number",                           :null => false
    t.integer  "summary_id"
    t.integer  "pos_votes",     :default => 0
    t.integer  "total_votes",   :default => 0
    t.boolean  "summarized",    :default => false
    t.boolean  "finished",      :default => false
    t.datetime "created_at"
    t.datetime "summarized_at"
    t.datetime "finished_at"
    t.float    "activity"
  end

  create_table "comments", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "bill_id"
    t.integer  "user_id"
    t.integer  "point_id"
    t.text     "text"
    t.integer  "best",        :default => 0
    t.integer  "score",       :default => 0
    t.integer  "pos_votes",   :default => 0
    t.integer  "total_votes", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "can_vote",    :default => true
    t.integer  "warnings",    :default => 0,     :null => false
    t.boolean  "deleted",     :default => false, :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title",      :null => false
    t.string   "permalink",  :null => false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["permalink"], :name => "index_pages_on_permalink"

  create_table "points", :force => true do |t|
    t.integer  "bill_id"
    t.integer  "user_id"
    t.integer  "comment_id"
    t.text     "text"
    t.boolean  "is_positive"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "politicians", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "party"
    t.string   "position"
    t.string   "state"
    t.string   "district"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "party"
    t.integer  "view"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "summaries", :force => true do |t|
    t.integer  "bill_id"
    t.integer  "user_id"
    t.text     "text"
    t.string   "comment"
    t.datetime "created_at"
    t.string   "cached_tag_list"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "username",        :limit => 64,                        :null => false
    t.string   "email",           :limit => 128,                       :null => false
    t.string   "hashed_password", :limit => 64
    t.boolean  "enabled",                        :default => true,     :null => false
    t.string   "roles",                          :default => "--- []"
    t.datetime "created_at"
    t.datetime "last_login_at"
    t.integer  "karma",                          :default => 0
    t.integer  "profile_id"
    t.integer  "warnings_count",                 :default => 0,        :null => false
  end

  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "fk_voteables"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "uniq_one_vote_only", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "fk_voters"

  create_table "warnings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "reported_by_id"
    t.integer  "type_id"
    t.string   "type"
    t.integer  "revert_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "warnings", ["reported_by_id", "type_id"], :name => "unique_one_report_only", :unique => true

end
