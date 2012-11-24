require "spec_helper"

describe "user registration" do
  it "allows new users to register with an email address and password" do
    visit "/users/sign_up"

    fill_in "Email",                 :with => "srih4ri@gmail.com"
    fill_in "user_password",              :with => "password"
    fill_in "user_password_confirmation", :with => "password"

    click_button "Sign up"

    page.should have_content("Welcome! You have signed up successfully.")
  end
end
