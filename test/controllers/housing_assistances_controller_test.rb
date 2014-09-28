require 'test_helper'

class HousingAssistancesControllerTest < ActionController::TestCase
  setup do
    @housing_assistance = housing_assistances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:housing_assistances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create housing_assistance" do
    assert_difference('HousingAssistance.count') do
      post :create, housing_assistance: { housing_dependent_no: @housing_assistance.housing_dependent_no, housing_gross_income: @housing_assistance.housing_gross_income }
    end

    assert_redirected_to housing_assistance_path(assigns(:housing_assistance))
  end

  test "should show housing_assistance" do
    get :show, id: @housing_assistance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @housing_assistance
    assert_response :success
  end

  test "should update housing_assistance" do
    patch :update, id: @housing_assistance, housing_assistance: { housing_dependent_no: @housing_assistance.housing_dependent_no, housing_gross_income: @housing_assistance.housing_gross_income }
    assert_redirected_to housing_assistance_path(assigns(:housing_assistance))
  end

  test "should destroy housing_assistance" do
    assert_difference('HousingAssistance.count', -1) do
      delete :destroy, id: @housing_assistance
    end

    assert_redirected_to housing_assistances_path
  end
end
