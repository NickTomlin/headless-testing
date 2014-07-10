require "spec_helper"

describe "My Application", :sauce => true do
  it "loads the homepage" do
    visit "/"
    expect(page.title).to include("Testing Testing")
  end

  it "provides the user with helpful feedback when clicking the button" do
    visit "/"
    click_button("click")

    content = page.find('#content')
    expect(content.text).to include("Change!")
  end
end
