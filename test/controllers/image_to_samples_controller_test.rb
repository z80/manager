require 'test_helper'

class ImageToSamplesControllerTest < ActionController::TestCase
  setup do
    @image_to_sample = image_to_samples(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:image_to_samples)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create image_to_sample" do
    assert_difference('ImageToSample.count') do
      post :create, image_to_sample: { image_id: @image_to_sample.image_id, sample_id: @image_to_sample.sample_id }
    end

    assert_redirected_to image_to_sample_path(assigns(:image_to_sample))
  end

  test "should show image_to_sample" do
    get :show, id: @image_to_sample
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @image_to_sample
    assert_response :success
  end

  test "should update image_to_sample" do
    patch :update, id: @image_to_sample, image_to_sample: { image_id: @image_to_sample.image_id, sample_id: @image_to_sample.sample_id }
    assert_redirected_to image_to_sample_path(assigns(:image_to_sample))
  end

  test "should destroy image_to_sample" do
    assert_difference('ImageToSample.count', -1) do
      delete :destroy, id: @image_to_sample
    end

    assert_redirected_to image_to_samples_path
  end
end
