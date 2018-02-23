require 'rails_helper'

feature "Home Page" do

  scenario "visit" do
    visit "/"
    expect(page).to have_css "h1", text: "BookStore"
    expect(page).to have_css "p", text: "The biggest bookstore! Easy to find your favor books"
  end

end