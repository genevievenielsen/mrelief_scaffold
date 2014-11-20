require 'test_helper'

class AabdCashesControllerTest < ActionController::TestCase
  setup do
    @aabd_cash = aabd_cashes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:aabd_cashes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create aabd_cash" do
    assert_difference('AabdCash.count') do
      post :create, aabd_cash: {  }
    end

    assert_redirected_to aabd_cash_path(assigns(:aabd_cash))
  end

  test "should show aabd_cash" do
    get :show, id: @aabd_cash
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @aabd_cash
    assert_response :success
  end

  test "should update aabd_cash" do
    patch :update, id: @aabd_cash, aabd_cash: {  }
    assert_redirected_to aabd_cash_path(assigns(:aabd_cash))
  end

  test "should destroy aabd_cash" do
    assert_difference('AabdCash.count', -1) do
      delete :destroy, id: @aabd_cash
    end

    assert_redirected_to aabd_cashes_path
  end
end
