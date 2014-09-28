require 'test_helper'

class RentalAssistancesControllerTest < ActionController::TestCase
  setup do
    @rental_assistance = rental_assistances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rental_assistances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rental_assistance" do
    assert_difference('RentalAssistance.count') do
      post :create, rental_assistance: { rental_dependent_no: @rental_assistance.rental_dependent_no, rental_gross_income: @rental_assistance.rental_gross_income, rental_status: @rental_assistance.rental_status }
    end

    assert_redirected_to rental_assistance_path(assigns(:rental_assistance))
  end

  test "should show rental_assistance" do
    get :show, id: @rental_assistance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rental_assistance
    assert_response :success
  end

  test "should update rental_assistance" do
    patch :update, id: @rental_assistance, rental_assistance: { rental_dependent_no: @rental_assistance.rental_dependent_no, rental_gross_income: @rental_assistance.rental_gross_income, rental_status: @rental_assistance.rental_status }
    assert_redirected_to rental_assistance_path(assigns(:rental_assistance))
  end

  test "should destroy rental_assistance" do
    assert_difference('RentalAssistance.count', -1) do
      delete :destroy, id: @rental_assistance
    end

    assert_redirected_to rental_assistances_path
  end
end
