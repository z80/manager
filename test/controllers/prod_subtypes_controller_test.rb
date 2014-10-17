require 'test_helper'

class ProdSubtypesControllerTest < ActionController::TestCase
  setup do
    @prod_subtype = prod_subtypes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prod_subtypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prod_subtype" do
    assert_difference('ProdSubtype.count') do
      post :create, prod_subtype: { belongs_id: @prod_subtype.belongs_id, contains_id: @prod_subtype.contains_id }
    end

    assert_redirected_to prod_subtype_path(assigns(:prod_subtype))
  end

  test "should show prod_subtype" do
    get :show, id: @prod_subtype
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @prod_subtype
    assert_response :success
  end

  test "should update prod_subtype" do
    patch :update, id: @prod_subtype, prod_subtype: { belongs_id: @prod_subtype.belongs_id, contains_id: @prod_subtype.contains_id }
    assert_redirected_to prod_subtype_path(assigns(:prod_subtype))
  end

  test "should destroy prod_subtype" do
    assert_difference('ProdSubtype.count', -1) do
      delete :destroy, id: @prod_subtype
    end

    assert_redirected_to prod_subtypes_path
  end
end
