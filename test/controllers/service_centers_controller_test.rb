require 'test_helper'

class ServiceCentersControllerTest < ActionController::TestCase
  setup do
    @service_center = service_centers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:service_centers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create service_center" do
    assert_difference('ServiceCenter.count') do
      post :create, service_center: { city: @service_center.city, latitude: @service_center.latitude, longitude: @service_center.longitude, name: @service_center.name, organization: @service_center.organization, phone: @service_center.phone, state: @service_center.state, street: @service_center.street, zip: @service_center.zip }
    end

    assert_redirected_to service_center_path(assigns(:service_center))
  end

  test "should show service_center" do
    get :show, id: @service_center
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @service_center
    assert_response :success
  end

  test "should update service_center" do
    patch :update, id: @service_center, service_center: { city: @service_center.city, latitude: @service_center.latitude, longitude: @service_center.longitude, name: @service_center.name, organization: @service_center.organization, phone: @service_center.phone, state: @service_center.state, street: @service_center.street, zip: @service_center.zip }
    assert_redirected_to service_center_path(assigns(:service_center))
  end

  test "should destroy service_center" do
    assert_difference('ServiceCenter.count', -1) do
      delete :destroy, id: @service_center
    end

    assert_redirected_to service_centers_path
  end
end
