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

ActiveRecord::Schema.define(version: 20170228201615) do

  create_table "answer_connections", force: :cascade do |t|
    t.integer  "answer_1_id"
    t.integer  "answer_2_id"
    t.float    "similarity",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["answer_1_id"], name: "index_answer_connections_on_answer_1_id"
    t.index ["answer_2_id"], name: "index_answer_connections_on_answer_2_id"
  end

  create_table "answer_test_case_results", force: :cascade do |t|
    t.integer  "answer_id"
    t.integer  "test_case_id"
    t.string   "output",       null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["answer_id", "test_case_id"], name: "index_answer_test_case_results_on_answer_id_and_test_case_id", unique: true
    t.index ["answer_id"], name: "index_answer_test_case_results_on_answer_id"
    t.index ["test_case_id"], name: "index_answer_test_case_results_on_test_case_id"
  end

  create_table "answers", force: :cascade do |t|
    t.string   "content",                           null: false
    t.boolean  "correct",           default: false, null: false
    t.boolean  "compilation_error", default: false
    t.string   "compiler_output"
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "team_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["team_id"], name: "index_answers_on_team_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "earned_scores", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.integer  "question_id"
    t.integer  "score"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_earned_scores_on_question_id"
    t.index ["team_id"], name: "index_earned_scores_on_team_id"
    t.index ["user_id"], name: "index_earned_scores_on_user_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.string   "title",       null: false
    t.string   "description", null: false
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id"], name: "index_exercises_on_user_id"
  end

  create_table "exercises_teams", force: :cascade do |t|
    t.integer  "exercise_id"
    t.integer  "team_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["exercise_id"], name: "index_exercises_teams_on_exercise_id"
    t.index ["team_id"], name: "index_exercises_teams_on_team_id"
  end

  create_table "question_dependencies", force: :cascade do |t|
    t.integer  "question_1_id"
    t.integer  "question_2_id"
    t.string   "operator",      default: ""
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["question_1_id"], name: "index_question_dependencies_on_question_1_id"
    t.index ["question_2_id"], name: "index_question_dependencies_on_question_2_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string   "title",                        null: false
    t.string   "description",                  null: false
    t.string   "operation",   default: "task", null: false
    t.float    "score",                        null: false
    t.integer  "exercise_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
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
    t.string   "title",       null: false
    t.string   "description"
    t.string   "input"
    t.string   "output",      null: false
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_test_cases_on_question_id"
  end

  create_table "user_connections", force: :cascade do |t|
    t.integer  "user_1_id"
    t.integer  "user_2_id"
    t.float    "similarity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_1_id"], name: "index_user_connections_on_user_1_id"
    t.index ["user_2_id"], name: "index_user_connections_on_user_2_id"
  end

  create_table "user_scores", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.integer  "score",      default: 0, null: false
    t.datetime "computed"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["team_id"], name: "index_user_scores_on_team_id"
    t.index ["user_id"], name: "index_user_scores_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "name",                                   null: false
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
    t.boolean  "teacher",                default: false, null: false
    t.boolean  "admin",                  default: false, null: false
    t.string   "anonymous_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
