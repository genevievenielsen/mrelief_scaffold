require 'test_helper'

class AllCityProgramDataControllerTest < ActionController::TestCase
  setup do
    @all_city_program_datum = all_city_program_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:all_city_program_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create all_city_program_datum" do
    assert_difference('AllCityProgramDatum.count') do
      post :create, all_city_program_datum: { aabd_eligibility_status: @all_city_program_datum.aabd_eligibility_status, age: @all_city_program_datum.age, all_kids_eligibility_status: @all_city_program_datum.all_kids_eligibility_status, annual_gross_income: @all_city_program_datum.annual_gross_income, anticipate_other_income: @all_city_program_datum.anticipate_other_income, assets: @all_city_program_datum.assets, child_health_insurance_state: @all_city_program_datum.child_health_insurance_state, child_in_school: @all_city_program_datum.child_in_school, child_support: @all_city_program_datum.child_support, citizen: @all_city_program_datum.citizen, dependent_no: @all_city_program_datum.dependent_no, disabled_status: @all_city_program_datum.disabled_status, enrolled_in_education: @all_city_program_datum.enrolled_in_education, medicaid_eligibility_status: @all_city_program_datum.medicaid_eligibility_status, medicare_cost_sharing_eligibility_status: @all_city_program_datum.medicare_cost_sharing_eligibility_status, medicare_household_size: @all_city_program_datum.medicare_household_size, monthly_benefits: @all_city_program_datum.monthly_benefits, monthly_gross_income: @all_city_program_datum.monthly_gross_income, name_on_lease: @all_city_program_datum.name_on_lease, ninety_day_gross_income: @all_city_program_datum.ninety_day_gross_income, number_of_children: @all_city_program_datum.number_of_children, pregnant: @all_city_program_datum.pregnant, pregnant_or_caring_for_child: @all_city_program_datum.pregnant_or_caring_for_child, pregnant_with_first_child: @all_city_program_datum.pregnant_with_first_child, relationship_to_child: @all_city_program_datum.relationship_to_child, rental_eligibility_status: @all_city_program_datum.rental_eligibility_status, rental_status: @all_city_program_datum.rental_status, rta_eligibility_status: @all_city_program_datum.rta_eligibility_status, snap_eligibility_status: @all_city_program_datum.snap_eligibility_status, ssi: @all_city_program_datum.ssi, tanf_eligibility_status: @all_city_program_datum.tanf_eligibility_status, tanif_sixty_months: @all_city_program_datum.tanif_sixty_months, teen_parent: @all_city_program_datum.teen_parent, zipcode: @all_city_program_datum.zipcode }
    end

    assert_redirected_to all_city_program_datum_path(assigns(:all_city_program_datum))
  end

  test "should show all_city_program_datum" do
    get :show, id: @all_city_program_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @all_city_program_datum
    assert_response :success
  end

  test "should update all_city_program_datum" do
    patch :update, id: @all_city_program_datum, all_city_program_datum: { aabd_eligibility_status: @all_city_program_datum.aabd_eligibility_status, age: @all_city_program_datum.age, all_kids_eligibility_status: @all_city_program_datum.all_kids_eligibility_status, annual_gross_income: @all_city_program_datum.annual_gross_income, anticipate_other_income: @all_city_program_datum.anticipate_other_income, assets: @all_city_program_datum.assets, child_health_insurance_state: @all_city_program_datum.child_health_insurance_state, child_in_school: @all_city_program_datum.child_in_school, child_support: @all_city_program_datum.child_support, citizen: @all_city_program_datum.citizen, dependent_no: @all_city_program_datum.dependent_no, disabled_status: @all_city_program_datum.disabled_status, enrolled_in_education: @all_city_program_datum.enrolled_in_education, medicaid_eligibility_status: @all_city_program_datum.medicaid_eligibility_status, medicare_cost_sharing_eligibility_status: @all_city_program_datum.medicare_cost_sharing_eligibility_status, medicare_household_size: @all_city_program_datum.medicare_household_size, monthly_benefits: @all_city_program_datum.monthly_benefits, monthly_gross_income: @all_city_program_datum.monthly_gross_income, name_on_lease: @all_city_program_datum.name_on_lease, ninety_day_gross_income: @all_city_program_datum.ninety_day_gross_income, number_of_children: @all_city_program_datum.number_of_children, pregnant: @all_city_program_datum.pregnant, pregnant_or_caring_for_child: @all_city_program_datum.pregnant_or_caring_for_child, pregnant_with_first_child: @all_city_program_datum.pregnant_with_first_child, relationship_to_child: @all_city_program_datum.relationship_to_child, rental_eligibility_status: @all_city_program_datum.rental_eligibility_status, rental_status: @all_city_program_datum.rental_status, rta_eligibility_status: @all_city_program_datum.rta_eligibility_status, snap_eligibility_status: @all_city_program_datum.snap_eligibility_status, ssi: @all_city_program_datum.ssi, tanf_eligibility_status: @all_city_program_datum.tanf_eligibility_status, tanif_sixty_months: @all_city_program_datum.tanif_sixty_months, teen_parent: @all_city_program_datum.teen_parent, zipcode: @all_city_program_datum.zipcode }
    assert_redirected_to all_city_program_datum_path(assigns(:all_city_program_datum))
  end

  test "should destroy all_city_program_datum" do
    assert_difference('AllCityProgramDatum.count', -1) do
      delete :destroy, id: @all_city_program_datum
    end

    assert_redirected_to all_city_program_data_path
  end
end
