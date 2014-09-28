require 'test_helper'

class ChildCareVouchersControllerTest < ActionController::TestCase
  setup do
    @child_care_voucher = child_care_vouchers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:child_care_vouchers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create child_care_voucher" do
    assert_difference('ChildCareVoucher.count') do
      post :create, child_care_voucher: { ccdf_dependent_no: @child_care_voucher.ccdf_dependent_no, ccdf_eligible_children: @child_care_voucher.ccdf_eligible_children, ccdf_gross_income: @child_care_voucher.ccdf_gross_income }
    end

    assert_redirected_to child_care_voucher_path(assigns(:child_care_voucher))
  end

  test "should show child_care_voucher" do
    get :show, id: @child_care_voucher
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @child_care_voucher
    assert_response :success
  end

  test "should update child_care_voucher" do
    patch :update, id: @child_care_voucher, child_care_voucher: { ccdf_dependent_no: @child_care_voucher.ccdf_dependent_no, ccdf_eligible_children: @child_care_voucher.ccdf_eligible_children, ccdf_gross_income: @child_care_voucher.ccdf_gross_income }
    assert_redirected_to child_care_voucher_path(assigns(:child_care_voucher))
  end

  test "should destroy child_care_voucher" do
    assert_difference('ChildCareVoucher.count', -1) do
      delete :destroy, id: @child_care_voucher
    end

    assert_redirected_to child_care_vouchers_path
  end
end
