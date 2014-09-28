require 'test_helper'

class WicsControllerTest < ActionController::TestCase
  setup do
    @wic = wics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wic" do
    assert_difference('Wic.count') do
      post :create, wic: { wic_gross_income: @wic.wic_gross_income, wic_household_size: @wic.wic_household_size }
    end

    assert_redirected_to wic_path(assigns(:wic))
  end

  test "should show wic" do
    get :show, id: @wic
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wic
    assert_response :success
  end

  test "should update wic" do
    patch :update, id: @wic, wic: { wic_gross_income: @wic.wic_gross_income, wic_household_size: @wic.wic_household_size }
    assert_redirected_to wic_path(assigns(:wic))
  end

  test "should destroy wic" do
    assert_difference('Wic.count', -1) do
      delete :destroy, id: @wic
    end

    assert_redirected_to wics_path
  end
end
