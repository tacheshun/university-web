require 'test_helper'

module Students
  class AccessTest < ActionDispatch::IntegrationTest
    story "As a User I want to access the application" do
      setup do
        @user = Factory(:user, :email => "rmu@test.com",
          :password => "123456", :password_confirmation => "123456")
      end

      scenario "sign in" do
        visit root_path
        assert_current_path new_user_session_path

        fill_in "Email",    :with => "rmu@test.com"
        fill_in "Password", :with => "123456"
        click_button "Sign in"

        assert_current_path root_path
        assert_flash "Signed in successfully"
        assert_link "Logout"
      end

      scenario "attempt to sign in with invalid credentials" do
        visit new_user_session_path

        fill_in "Email",    :with => "rmu@test.com"
        fill_in "Password", :with => "654321"
        click_button "Sign in"

        assert_current_path new_user_session_path
        assert_content "Invalid email or password"
        assert_no_link "Logout"
      end

      scenario "sign out" do
        sign_user_in @user
        assert_current_path dashboard_path

        click_link "Logout"

        assert_current_path new_user_session_path
        assert_no_link "Logout"

        visit root_path
        assert_current_path new_user_session_path
        assert_content "You need to sign in before continuing."
      end
    end
  end
end
