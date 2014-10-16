require 'test_helper'

class LafCentersControllerTest < ActionController::TestCase
  setup do
    @laf_center = laf_centers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:laf_centers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create laf_center" do
    assert_difference('LafCenter.count') do
      post :create, laf_center: { address: @laf_center.address, center: @laf_center.center, city: @laf_center.city, contact: @laf_center.contact, spanish: @laf_center.spanish, telephone: @laf_center.telephone, zipcode: @laf_center.zipcode }
    end

    assert_redirected_to laf_center_path(assigns(:laf_center))
  end

  test "should show laf_center" do
    get :show, id: @laf_center
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @laf_center
    assert_response :success
  end

  test "should update laf_center" do
    patch :update, id: @laf_center, laf_center: { address: @laf_center.address, center: @laf_center.center, city: @laf_center.city, contact: @laf_center.contact, spanish: @laf_center.spanish, telephone: @laf_center.telephone, zipcode: @laf_center.zipcode }
    assert_redirected_to laf_center_path(assigns(:laf_center))
  end

  test "should destroy laf_center" do
    assert_difference('LafCenter.count', -1) do
      delete :destroy, id: @laf_center
    end

    assert_redirected_to laf_centers_path
  end
end
