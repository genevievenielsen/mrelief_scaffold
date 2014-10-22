require 'test_helper'

class TanifsControllerTest < ActionController::TestCase
  setup do
    @tanif = tanifs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tanifs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tanif" do
    assert_difference('Tanif.count') do
      post :create, tanif: { earned_income: @tanif.earned_income, household_size: @tanif.household_size, max_income: @tanif.max_income, tanif_payment: @tanif.tanif_payment }
    end

    assert_redirected_to tanif_path(assigns(:tanif))
  end

  test "should show tanif" do
    get :show, id: @tanif
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tanif
    assert_response :success
  end

  test "should update tanif" do
    patch :update, id: @tanif, tanif: { earned_income: @tanif.earned_income, household_size: @tanif.household_size, max_income: @tanif.max_income, tanif_payment: @tanif.tanif_payment }
    assert_redirected_to tanif_path(assigns(:tanif))
  end

  test "should destroy tanif" do
    assert_difference('Tanif.count', -1) do
      delete :destroy, id: @tanif
    end

    assert_redirected_to tanifs_path
  end
end
