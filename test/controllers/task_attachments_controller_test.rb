require 'test_helper'

class TaskAttachmentsControllerTest < ActionController::TestCase
  test "should get destroy" do
    get :destroy
    assert_response :success
  end

  test "should get download_attachment" do
    get :download_attachment
    assert_response :success
  end

end
