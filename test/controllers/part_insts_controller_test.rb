require 'test_helper'

class PartInstsControllerTest < ActionController::TestCase
  setup do
    @part_inst = part_insts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:part_insts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create part_inst" do
    assert_difference('PartInst.count') do
      post :create, part_inst: { box_id: @part_inst.box_id, cnt: @part_inst.cnt, part_id: @part_inst.part_id }
    end

    assert_redirected_to part_inst_path(assigns(:part_inst))
  end

  test "should show part_inst" do
    get :show, id: @part_inst
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @part_inst
    assert_response :success
  end

  test "should update part_inst" do
    patch :update, id: @part_inst, part_inst: { box_id: @part_inst.box_id, cnt: @part_inst.cnt, part_id: @part_inst.part_id }
    assert_redirected_to part_inst_path(assigns(:part_inst))
  end

  test "should destroy part_inst" do
    assert_difference('PartInst.count', -1) do
      delete :destroy, id: @part_inst
    end

    assert_redirected_to part_insts_path
  end
end
