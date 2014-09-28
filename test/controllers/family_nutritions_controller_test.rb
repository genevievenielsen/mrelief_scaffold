require 'test_helper'

class FamilyNutritionsControllerTest < ActionController::TestCase
  setup do
    @family_nutrition = family_nutritions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:family_nutritions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create family_nutrition" do
    assert_difference('FamilyNutrition.count') do
      post :create, family_nutrition: { nutrition_gross_income: @family_nutrition.nutrition_gross_income, nutrition_household_size: @family_nutrition.nutrition_household_size }
    end

    assert_redirected_to family_nutrition_path(assigns(:family_nutrition))
  end

  test "should show family_nutrition" do
    get :show, id: @family_nutrition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @family_nutrition
    assert_response :success
  end

  test "should update family_nutrition" do
    patch :update, id: @family_nutrition, family_nutrition: { nutrition_gross_income: @family_nutrition.nutrition_gross_income, nutrition_household_size: @family_nutrition.nutrition_household_size }
    assert_redirected_to family_nutrition_path(assigns(:family_nutrition))
  end

  test "should destroy family_nutrition" do
    assert_difference('FamilyNutrition.count', -1) do
      delete :destroy, id: @family_nutrition
    end

    assert_redirected_to family_nutritions_path
  end
end
