require 'spec_helper'

describe "UserSignin" do
  it "allows users to signin after they have registered" do
    user = User.create(:email => 'srih4ri@gmail.com',:password => 'possword')
    visit "/users/sign_in"
    fill_in "user_email", :with => 'srih4ri@gmail.com'
    fill_in "user_password", :with => 'possword'

    click_button 'Sign in'

    page.should have_content('Signed in successfully.')
  end

end
