require 'test_helper'

class AllKidsControllerTest < ActionController::TestCase
  setup do
    @all_kid = all_kids(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:all_kids)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create all_kid" do
    assert_difference('AllKid.count') do
      post :create, all_kid: { assist_gross_income: @all_kid.assist_gross_income, kids_household_size: @all_kid.kids_household_size, premium_1_gross_income: @all_kid.premium_1_gross_income, premium_2_gross_income: @all_kid.premium_2_gross_income, share_gross_income: @all_kid.share_gross_income }
    end

    assert_redirected_to all_kid_path(assigns(:all_kid))
  end

  test "should show all_kid" do
    get :show, id: @all_kid
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @all_kid
    assert_response :success
  end

  test "should update all_kid" do
    patch :update, id: @all_kid, all_kid: { assist_gross_income: @all_kid.assist_gross_income, kids_household_size: @all_kid.kids_household_size, premium_1_gross_income: @all_kid.premium_1_gross_income, premium_2_gross_income: @all_kid.premium_2_gross_income, share_gross_income: @all_kid.share_gross_income }
    assert_redirected_to all_kid_path(assigns(:all_kid))
  end

  test "should destroy all_kid" do
    assert_difference('AllKid.count', -1) do
      delete :destroy, id: @all_kid
    end

    assert_redirected_to all_kids_path
  end
end
