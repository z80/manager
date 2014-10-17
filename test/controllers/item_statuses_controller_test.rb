require 'test_helper'

class ItemStatusesControllerTest < ActionController::TestCase
  setup do
    @item_status = item_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:item_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item_status" do
    assert_difference('ItemStatus.count') do
      post :create, item_status: { name: @item_status.name }
    end

    assert_redirected_to item_status_path(assigns(:item_status))
  end

  test "should show item_status" do
    get :show, id: @item_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @item_status
    assert_response :success
  end

  test "should update item_status" do
    patch :update, id: @item_status, item_status: { name: @item_status.name }
    assert_redirected_to item_status_path(assigns(:item_status))
  end

  test "should destroy item_status" do
    assert_difference('ItemStatus.count', -1) do
      delete :destroy, id: @item_status
    end

    assert_redirected_to item_statuses_path
  end
end
