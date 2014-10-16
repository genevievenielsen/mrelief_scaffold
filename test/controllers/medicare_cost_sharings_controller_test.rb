require 'test_helper'

class MedicareCostSharingsControllerTest < ActionController::TestCase
  setup do
    @medicare_cost_sharing = medicare_cost_sharings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:medicare_cost_sharings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create medicare_cost_sharing" do
    assert_difference('MedicareCostSharing.count') do
      post :create, medicare_cost_sharing: { household_size: @medicare_cost_sharing.household_size, medicare_cost_sharing: @medicare_cost_sharing.medicare_cost_sharing, premium_only: @medicare_cost_sharing.premium_only }
    end

    assert_redirected_to medicare_cost_sharing_path(assigns(:medicare_cost_sharing))
  end

  test "should show medicare_cost_sharing" do
    get :show, id: @medicare_cost_sharing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @medicare_cost_sharing
    assert_response :success
  end

  test "should update medicare_cost_sharing" do
    patch :update, id: @medicare_cost_sharing, medicare_cost_sharing: { household_size: @medicare_cost_sharing.household_size, medicare_cost_sharing: @medicare_cost_sharing.medicare_cost_sharing, premium_only: @medicare_cost_sharing.premium_only }
    assert_redirected_to medicare_cost_sharing_path(assigns(:medicare_cost_sharing))
  end

  test "should destroy medicare_cost_sharing" do
    assert_difference('MedicareCostSharing.count', -1) do
      delete :destroy, id: @medicare_cost_sharing
    end

    assert_redirected_to medicare_cost_sharings_path
  end
end
