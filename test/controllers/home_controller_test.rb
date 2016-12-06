require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get layout" do
    get :layout
    assert_response :success
  end

end
