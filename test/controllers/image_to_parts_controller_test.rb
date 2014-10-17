require 'test_helper'

class ImageToPartsControllerTest < ActionController::TestCase
  setup do
    @image_to_part = image_to_parts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:image_to_parts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create image_to_part" do
    assert_difference('ImageToPart.count') do
      post :create, image_to_part: { image_id: @image_to_part.image_id, part_id: @image_to_part.part_id }
    end

    assert_redirected_to image_to_part_path(assigns(:image_to_part))
  end

  test "should show image_to_part" do
    get :show, id: @image_to_part
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @image_to_part
    assert_response :success
  end

  test "should update image_to_part" do
    patch :update, id: @image_to_part, image_to_part: { image_id: @image_to_part.image_id, part_id: @image_to_part.part_id }
    assert_redirected_to image_to_part_path(assigns(:image_to_part))
  end

  test "should destroy image_to_part" do
    assert_difference('ImageToPart.count', -1) do
      delete :destroy, id: @image_to_part
    end

    assert_redirected_to image_to_parts_path
  end
end
