require 'test_helper'

class AutoRepairAssistancesControllerTest < ActionController::TestCase
  setup do
    @auto_repair_assistance = auto_repair_assistances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:auto_repair_assistances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create auto_repair_assistance" do
    assert_difference('AutoRepairAssistance.count') do
      post :create, auto_repair_assistance: { auto_gross_income: @auto_repair_assistance.auto_gross_income, auto_household_size: @auto_repair_assistance.auto_household_size }
    end

    assert_redirected_to auto_repair_assistance_path(assigns(:auto_repair_assistance))
  end

  test "should show auto_repair_assistance" do
    get :show, id: @auto_repair_assistance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @auto_repair_assistance
    assert_response :success
  end

  test "should update auto_repair_assistance" do
    patch :update, id: @auto_repair_assistance, auto_repair_assistance: { auto_gross_income: @auto_repair_assistance.auto_gross_income, auto_household_size: @auto_repair_assistance.auto_household_size }
    assert_redirected_to auto_repair_assistance_path(assigns(:auto_repair_assistance))
  end

  test "should destroy auto_repair_assistance" do
    assert_difference('AutoRepairAssistance.count', -1) do
      delete :destroy, id: @auto_repair_assistance
    end

    assert_redirected_to auto_repair_assistances_path
  end
end
