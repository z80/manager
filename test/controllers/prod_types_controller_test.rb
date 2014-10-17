require 'test_helper'

class ProdTypesControllerTest < ActionController::TestCase
  setup do
    @prod_type = prod_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prod_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prod_type" do
    assert_difference('ProdType.count') do
      post :create, prod_type: { desc: @prod_type.desc, own_id: @prod_type.own_id, part_id: @prod_type.part_id }
    end

    assert_redirected_to prod_type_path(assigns(:prod_type))
  end

  test "should show prod_type" do
    get :show, id: @prod_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @prod_type
    assert_response :success
  end

  test "should update prod_type" do
    patch :update, id: @prod_type, prod_type: { desc: @prod_type.desc, own_id: @prod_type.own_id, part_id: @prod_type.part_id }
    assert_redirected_to prod_type_path(assigns(:prod_type))
  end

  test "should destroy prod_type" do
    assert_difference('ProdType.count', -1) do
      delete :destroy, id: @prod_type
    end

    assert_redirected_to prod_types_path
  end
end
