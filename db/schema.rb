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

ActiveRecord::Schema.define(:version => 20120408112847) do

  create_table "committees", :force => true do |t|
    t.string   "external_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "committees_representatives", :id => false, :force => true do |t|
    t.integer "committee_id"
    t.integer "representative_id"
  end

  add_index "committees_representatives", ["committee_id", "representative_id"], :name => "index_com_reps"

  create_table "districts", :force => true do |t|
    t.string   "external_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "issues", :force => true do |t|
    t.string   "external_id"
    t.string   "summary"
    t.string   "description"
    t.string   "issue_type"
    t.string   "status"
    t.datetime "last_update"
    t.string   "document_group"
    t.string   "reference"
    t.integer  "committee_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "issues_topics", :id => false, :force => true do |t|
    t.integer "issue_id"
    t.integer "topic_id"
  end

  add_index "issues_topics", ["issue_id", "topic_id"], :name => "index_issues_topics_on_issue_id_and_topic_id"

  create_table "parties", :force => true do |t|
    t.string   "external_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "representatives", :force => true do |t|
    t.string   "external_id"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "party_id"
    t.integer  "district_id"
  end

  create_table "topics", :force => true do |t|
    t.string   "external_id"
    t.integer  "parent_id"
    t.string   "name"
    t.boolean  "main"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
