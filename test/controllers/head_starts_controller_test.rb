require 'test_helper'

class HeadStartsControllerTest < ActionController::TestCase
  setup do
    @head_start = head_starts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:head_starts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create head_start" do
    assert_difference('HeadStart.count') do
      post :create, head_start: { hs_dependent_no: @head_start.hs_dependent_no, hs_gross_income: @head_start.hs_gross_income }
    end

    assert_redirected_to head_start_path(assigns(:head_start))
  end

  test "should show head_start" do
    get :show, id: @head_start
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @head_start
    assert_response :success
  end

  test "should update head_start" do
    patch :update, id: @head_start, head_start: { hs_dependent_no: @head_start.hs_dependent_no, hs_gross_income: @head_start.hs_gross_income }
    assert_redirected_to head_start_path(assigns(:head_start))
  end

  test "should destroy head_start" do
    assert_difference('HeadStart.count', -1) do
      delete :destroy, id: @head_start
    end

    assert_redirected_to head_starts_path
  end
end
