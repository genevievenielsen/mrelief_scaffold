require 'test_helper'

class RtaFreeRidesControllerTest < ActionController::TestCase
  setup do
    @rta_free_ride = rta_free_rides(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rta_free_rides)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rta_free_ride" do
    assert_difference('RtaFreeRide.count') do
      post :create, rta_free_ride: { rta_dependent_no: @rta_free_ride.rta_dependent_no, rta_gross_income: @rta_free_ride.rta_gross_income }
    end

    assert_redirected_to rta_free_ride_path(assigns(:rta_free_ride))
  end

  test "should show rta_free_ride" do
    get :show, id: @rta_free_ride
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rta_free_ride
    assert_response :success
  end

  test "should update rta_free_ride" do
    patch :update, id: @rta_free_ride, rta_free_ride: { rta_dependent_no: @rta_free_ride.rta_dependent_no, rta_gross_income: @rta_free_ride.rta_gross_income }
    assert_redirected_to rta_free_ride_path(assigns(:rta_free_ride))
  end

  test "should destroy rta_free_ride" do
    assert_difference('RtaFreeRide.count', -1) do
      delete :destroy, id: @rta_free_ride
    end

    assert_redirected_to rta_free_rides_path
  end
end
