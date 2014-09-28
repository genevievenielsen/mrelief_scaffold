require 'test_helper'

class MedicaidsControllerTest < ActionController::TestCase
  setup do
    @medicaid = medicaids(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:medicaids)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create medicaid" do
    assert_difference('Medicaid.count') do
      post :create, medicaid: { medicaid_gross_income: @medicaid.medicaid_gross_income, medicaid_household_size: @medicaid.medicaid_household_size }
    end

    assert_redirected_to medicaid_path(assigns(:medicaid))
  end

  test "should show medicaid" do
    get :show, id: @medicaid
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @medicaid
    assert_response :success
  end

  test "should update medicaid" do
    patch :update, id: @medicaid, medicaid: { medicaid_gross_income: @medicaid.medicaid_gross_income, medicaid_household_size: @medicaid.medicaid_household_size }
    assert_redirected_to medicaid_path(assigns(:medicaid))
  end

  test "should destroy medicaid" do
    assert_difference('Medicaid.count', -1) do
      delete :destroy, id: @medicaid
    end

    assert_redirected_to medicaids_path
  end
end
