require 'test_helper'

class PartTypesControllerTest < ActionController::TestCase
  setup do
    @part_type = part_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:part_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create part_type" do
    assert_difference('PartType.count') do
      post :create, part_type: { name: @part_type.name }
    end

    assert_redirected_to part_type_path(assigns(:part_type))
  end

  test "should show part_type" do
    get :show, id: @part_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @part_type
    assert_response :success
  end

  test "should update part_type" do
    patch :update, id: @part_type, part_type: { name: @part_type.name }
    assert_redirected_to part_type_path(assigns(:part_type))
  end

  test "should destroy part_type" do
    assert_difference('PartType.count', -1) do
      delete :destroy, id: @part_type
    end

    assert_redirected_to part_types_path
  end
end
