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

ActiveRecord::Schema.define(version: 20170114181104) do

  create_table "answer_test_case_results", force: :cascade do |t|
    t.integer  "answer_id"
    t.integer  "test_case_id"
    t.string   "output"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["answer_id"], name: "index_answer_test_case_results_on_answer_id"
    t.index ["test_case_id"], name: "index_answer_test_case_results_on_test_case_id"
  end

  create_table "answers", force: :cascade do |t|
    t.string   "content",                     null: false
    t.boolean  "correct",     default: false, null: false
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.string   "title",              null: false
    t.string   "description",        null: false
    t.integer  "learning_object_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "user_id"
    t.index ["learning_object_id"], name: "index_exercises_on_learning_object_id"
    t.index ["user_id"], name: "index_exercises_on_user_id"
  end

  create_table "exercises_learning_objects", force: :cascade do |t|
    t.integer "exercise_id"
    t.integer "learning_object_id"
    t.index ["exercise_id"], name: "index_exercises_learning_objects_on_exercise_id"
    t.index ["learning_object_id"], name: "index_exercises_learning_objects_on_learning_object_id"
  end

  create_table "exercises_teams", force: :cascade do |t|
    t.integer "exercise_id"
    t.integer "team_id"
    t.index ["exercise_id"], name: "index_exercises_teams_on_exercise_id"
    t.index ["team_id"], name: "index_exercises_teams_on_team_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string   "description", null: false
    t.integer  "exercise_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["exercise_id"], name: "index_questions_on_exercise_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "password_digest",                null: false
    t.string   "name",                           null: false
    t.boolean  "active",          default: true, null: false
    t.integer  "owner_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["owner_id"], name: "index_teams_on_owner_id"
  end

  create_table "teams_users", force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
    t.index ["team_id"], name: "index_teams_users_on_team_id"
    t.index ["user_id"], name: "index_teams_users_on_user_id"
  end

  create_table "test_cases", force: :cascade do |t|
    t.string   "description"
    t.string   "input"
    t.string   "output",      null: false
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "title",       null: false
    t.index ["question_id"], name: "index_test_cases_on_question_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name"
    t.boolean  "teacher",                default: false, null: false
    t.boolean  "admin",                  default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
