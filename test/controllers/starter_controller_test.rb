require 'test_helper'

class StarterControllerTest < ActionDispatch::IntegrationTest
  test "should get shower" do
    get starter_shower_url
    assert_response :success
  end

end
