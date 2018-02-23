require 'rails_helper'
RSpec.describe "User logs in and logs out", :type => :feature do

  # `js: true` spec metadata means this will run using the `:selenium`
  # browser driver configured in spec/support/capybara.rb
  scenario "with correct details", js: true do

    create(:user, email: "someone@example.tld", password: "somepassword")

    visit "/"

    click_link "Login"
    expect(page).to have_css("h2", text: "Log in")
    expect(current_path).to eq(new_user_session_path)

    login "someone@example.tld", "somepassword"

    expect(current_path).to eq "/"
    expect(page).to have_content "Hi, som"

    click_link "Hi, som"
    click_link "Logout"

    expect(current_path).to eq "/"
    expect(page).not_to have_content "someone@example.tld"

  end

  scenario "with wrong password" do

    create(:user, email: "e@example.tld", password: "test-password")

    visit new_user_session_path

    login "error@example.tld", "test-password2"

    expect(current_path).to eq(new_user_session_path)
    expect(page).not_to have_content "Hi, err"
  end


  private

  def login(email, password)
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Log in"
  end

end