require 'test_helper'

class SamplesControllerTest < ActionController::TestCase
  setup do
    @sample = samples(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:samples)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sample" do
    assert_difference('Sample.count') do
      post :create, sample: { desc: @sample.desc, due: @sample.due, from: @sample.from, received: @sample.received, user_placed: @sample.user_placed, user_resp: @sample.user_resp }
    end

    assert_redirected_to sample_path(assigns(:sample))
  end

  test "should show sample" do
    get :show, id: @sample
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sample
    assert_response :success
  end

  test "should update sample" do
    patch :update, id: @sample, sample: { desc: @sample.desc, due: @sample.due, from: @sample.from, received: @sample.received, user_placed: @sample.user_placed, user_resp: @sample.user_resp }
    assert_redirected_to sample_path(assigns(:sample))
  end

  test "should destroy sample" do
    assert_difference('Sample.count', -1) do
      delete :destroy, id: @sample
    end

    assert_redirected_to samples_path
  end
end
