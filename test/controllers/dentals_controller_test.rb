require 'test_helper'

class DentalsControllerTest < ActionController::TestCase
  setup do
    @dental = dentals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dentals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dental" do
    assert_difference('Dental.count') do
      post :create, dental: { dental_gross_income: @dental.dental_gross_income, dental_household_size: @dental.dental_household_size }
    end

    assert_redirected_to dental_path(assigns(:dental))
  end

  test "should show dental" do
    get :show, id: @dental
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dental
    assert_response :success
  end

  test "should update dental" do
    patch :update, id: @dental, dental: { dental_gross_income: @dental.dental_gross_income, dental_household_size: @dental.dental_household_size }
    assert_redirected_to dental_path(assigns(:dental))
  end

  test "should destroy dental" do
    assert_difference('Dental.count', -1) do
      delete :destroy, id: @dental
    end

    assert_redirected_to dentals_path
  end
end
