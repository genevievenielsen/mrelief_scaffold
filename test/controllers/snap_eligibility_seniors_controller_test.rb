require 'test_helper'

class SnapEligibilitySeniorsControllerTest < ActionController::TestCase
  setup do
    @snap_eligibility_senior = snap_eligibility_seniors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:snap_eligibility_seniors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create snap_eligibility_senior" do
    assert_difference('SnapEligibilitySenior.count') do
      post :create, snap_eligibility_senior: { snap_dependent_no: @snap_eligibility_senior.snap_dependent_no, snap_gross_income: @snap_eligibility_senior.snap_gross_income }
    end

    assert_redirected_to snap_eligibility_senior_path(assigns(:snap_eligibility_senior))
  end

  test "should show snap_eligibility_senior" do
    get :show, id: @snap_eligibility_senior
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @snap_eligibility_senior
    assert_response :success
  end

  test "should update snap_eligibility_senior" do
    patch :update, id: @snap_eligibility_senior, snap_eligibility_senior: { snap_dependent_no: @snap_eligibility_senior.snap_dependent_no, snap_gross_income: @snap_eligibility_senior.snap_gross_income }
    assert_redirected_to snap_eligibility_senior_path(assigns(:snap_eligibility_senior))
  end

  test "should destroy snap_eligibility_senior" do
    assert_difference('SnapEligibilitySenior.count', -1) do
      delete :destroy, id: @snap_eligibility_senior
    end

    assert_redirected_to snap_eligibility_seniors_path
  end
end
