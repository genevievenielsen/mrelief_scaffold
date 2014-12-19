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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141219144109) do

  create_table "aabd_cashes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "all_city_program_data", force: true do |t|
    t.integer  "dependent_no"
    t.integer  "medicare_household_size"
    t.integer  "age"
    t.integer  "monthly_gross_income"
    t.integer  "thirty_day_net_income"
    t.integer  "child_support"
    t.integer  "ssi"
    t.integer  "monthly_benefits"
    t.integer  "ninety_day_gross_income"
    t.integer  "annual_gross_income"
    t.integer  "assets"
    t.integer  "number_of_children"
    t.string   "enrolled_in_education"
    t.string   "citizen"
    t.string   "zipcode"
    t.string   "disabled_status"
    t.string   "name_on_lease"
    t.string   "rental_status"
    t.string   "pregnant"
    t.string   "child_health_insurance_state"
    t.string   "pregnant_or_caring_for_child"
    t.string   "relationship_to_child"
    t.string   "pregnant_with_first_child"
    t.string   "tanif_sixty_months"
    t.string   "anticipate_other_income"
    t.string   "teen_parent"
    t.string   "child_in_school"
    t.string   "snap_eligibility_status"
    t.string   "all_kids_eligibility_status"
    t.string   "rta_eligibility_status"
    t.string   "medicaid_eligibility_status"
    t.string   "medicare_cost_sharing_eligibility_status"
    t.string   "rental_eligibility_status"
    t.string   "aabd_eligibility_status"
    t.string   "tanf_eligibility_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "all_city_programs", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "all_kids", force: true do |t|
    t.integer  "kids_household_size"
    t.decimal  "assist_gross_income"
    t.decimal  "share_gross_income"
    t.decimal  "premium_1_gross_income"
    t.decimal  "premium_2_gross_income"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "auto_repair_assistances", force: true do |t|
    t.integer  "auto_household_size"
    t.decimal  "auto_gross_income"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "child_care_vouchers", force: true do |t|
    t.integer  "ccdf_dependent_no"
    t.integer  "ccdf_eligible_children"
    t.decimal  "ccdf_gross_income"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dentals", force: true do |t|
    t.decimal  "dental_gross_income"
    t.integer  "dental_household_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "early_head_starts", force: true do |t|
    t.integer  "ehs_dependent_no"
    t.decimal  "ehs_gross_income"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "family_nutritions", force: true do |t|
    t.decimal  "nutrition_gross_income"
    t.integer  "nutrition_household_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "head_starts", force: true do |t|
    t.integer  "hs_dependent_no"
    t.decimal  "hs_gross_income"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "housing_assistances", force: true do |t|
    t.integer  "housing_dependent_no"
    t.decimal  "housing_gross_income"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "laf_centers", force: true do |t|
    t.string   "zipcode"
    t.string   "city"
    t.string   "center"
    t.string   "address"
    t.string   "contact"
    t.string   "telephone"
    t.string   "spanish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medicaids", force: true do |t|
    t.integer  "medicaid_household_size"
    t.decimal  "medicaid_gross_income"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medicare_cost_sharings", force: true do |t|
    t.integer  "household_size"
    t.decimal  "medicare_cost_sharing"
    t.decimal  "premium_only"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "organization_id"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programs", force: true do |t|
    t.string   "category"
    t.string   "url"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description_es"
    t.string   "name_es"
    t.string   "description_en"
    t.string   "name_en"
  end

  create_table "rental_assistances", force: true do |t|
    t.integer  "rental_dependent_no"
    t.decimal  "rental_gross_income"
    t.integer  "rental_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rta_free_rides", force: true do |t|
    t.integer  "rta_dependent_no"
    t.decimal  "rta_gross_income"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_centers", force: true do |t|
    t.string   "name"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "organization"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "snap_eligibilities", force: true do |t|
    t.integer  "snap_dependent_no"
    t.decimal  "snap_gross_income"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snap_eligibility_seniors", force: true do |t|
    t.integer  "snap_dependent_no"
    t.decimal  "snap_gross_income"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tanifs", force: true do |t|
    t.integer  "household_size"
    t.decimal  "earned_income"
    t.integer  "tanif_payment"
    t.decimal  "max_income"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visions", force: true do |t|
    t.decimal  "vision_gross_income"
    t.integer  "vision_household_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wics", force: true do |t|
    t.integer  "wic_household_size"
    t.decimal  "wic_gross_income"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
