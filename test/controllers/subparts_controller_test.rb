require 'test_helper'

class SubpartsControllerTest < ActionController::TestCase
  setup do
    @subpart = subparts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subparts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subpart" do
    assert_difference('Subpart.count') do
      post :create, subpart: { belongs_id: @subpart.belongs_id, contains_id: @subpart.contains_id }
    end

    assert_redirected_to subpart_path(assigns(:subpart))
  end

  test "should show subpart" do
    get :show, id: @subpart
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subpart
    assert_response :success
  end

  test "should update subpart" do
    patch :update, id: @subpart, subpart: { belongs_id: @subpart.belongs_id, contains_id: @subpart.contains_id }
    assert_redirected_to subpart_path(assigns(:subpart))
  end

  test "should destroy subpart" do
    assert_difference('Subpart.count', -1) do
      delete :destroy, id: @subpart
    end

    assert_redirected_to subparts_path
  end
end
