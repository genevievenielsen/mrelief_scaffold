require 'test_helper'

class SnapEligibilitiesControllerTest < ActionController::TestCase
  setup do
    @snap_eligibility = snap_eligibilities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:snap_eligibilities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create snap_eligibility" do
    assert_difference('SnapEligibility.count') do
      post :create, snap_eligibility: { snap_dependent_no: @snap_eligibility.snap_dependent_no, snap_gross_income: @snap_eligibility.snap_gross_income }
    end

    assert_redirected_to snap_eligibility_path(assigns(:snap_eligibility))
  end

  test "should show snap_eligibility" do
    get :show, id: @snap_eligibility
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @snap_eligibility
    assert_response :success
  end

  test "should update snap_eligibility" do
    patch :update, id: @snap_eligibility, snap_eligibility: { snap_dependent_no: @snap_eligibility.snap_dependent_no, snap_gross_income: @snap_eligibility.snap_gross_income }
    assert_redirected_to snap_eligibility_path(assigns(:snap_eligibility))
  end

  test "should destroy snap_eligibility" do
    assert_difference('SnapEligibility.count', -1) do
      delete :destroy, id: @snap_eligibility
    end

    assert_redirected_to snap_eligibilities_path
  end
end
