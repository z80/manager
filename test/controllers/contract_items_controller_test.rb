require 'test_helper'

class ContractItemsControllerTest < ActionController::TestCase
  setup do
    @contract_item = contract_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contract_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contract_item" do
    assert_difference('ContractItem.count') do
      post :create, contract_item: { contract_id: @contract_item.contract_id, prod_type_id: @contract_item.prod_type_id, product_id: @contract_item.product_id }
    end

    assert_redirected_to contract_item_path(assigns(:contract_item))
  end

  test "should show contract_item" do
    get :show, id: @contract_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contract_item
    assert_response :success
  end

  test "should update contract_item" do
    patch :update, id: @contract_item, contract_item: { contract_id: @contract_item.contract_id, prod_type_id: @contract_item.prod_type_id, product_id: @contract_item.product_id }
    assert_redirected_to contract_item_path(assigns(:contract_item))
  end

  test "should destroy contract_item" do
    assert_difference('ContractItem.count', -1) do
      delete :destroy, id: @contract_item
    end

    assert_redirected_to contract_items_path
  end
end
