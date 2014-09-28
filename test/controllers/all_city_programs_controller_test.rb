require 'test_helper'

class AllCityProgramsControllerTest < ActionController::TestCase
  setup do
    @all_city_program = all_city_programs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:all_city_programs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create all_city_program" do
    assert_difference('AllCityProgram.count') do
      post :create, all_city_program: {  }
    end

    assert_redirected_to all_city_program_path(assigns(:all_city_program))
  end

  test "should show all_city_program" do
    get :show, id: @all_city_program
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @all_city_program
    assert_response :success
  end

  test "should update all_city_program" do
    patch :update, id: @all_city_program, all_city_program: {  }
    assert_redirected_to all_city_program_path(assigns(:all_city_program))
  end

  test "should destroy all_city_program" do
    assert_difference('AllCityProgram.count', -1) do
      delete :destroy, id: @all_city_program
    end

    assert_redirected_to all_city_programs_path
  end
end
