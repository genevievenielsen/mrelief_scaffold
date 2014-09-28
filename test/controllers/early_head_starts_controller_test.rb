require 'test_helper'

class EarlyHeadStartsControllerTest < ActionController::TestCase
  setup do
    @early_head_start = early_head_starts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:early_head_starts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create early_head_start" do
    assert_difference('EarlyHeadStart.count') do
      post :create, early_head_start: { ehs_dependent_no: @early_head_start.ehs_dependent_no, ehs_gross_income: @early_head_start.ehs_gross_income }
    end

    assert_redirected_to early_head_start_path(assigns(:early_head_start))
  end

  test "should show early_head_start" do
    get :show, id: @early_head_start
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @early_head_start
    assert_response :success
  end

  test "should update early_head_start" do
    patch :update, id: @early_head_start, early_head_start: { ehs_dependent_no: @early_head_start.ehs_dependent_no, ehs_gross_income: @early_head_start.ehs_gross_income }
    assert_redirected_to early_head_start_path(assigns(:early_head_start))
  end

  test "should destroy early_head_start" do
    assert_difference('EarlyHeadStart.count', -1) do
      delete :destroy, id: @early_head_start
    end

    assert_redirected_to early_head_starts_path
  end
end
