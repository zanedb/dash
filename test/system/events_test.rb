require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @event = events(:one)
  end

  test "visiting the index" do
    visit events_url
    assert_selector "h1", text: "Events"
  end

  test "creating a Event" do
    visit events_url
    click_on "New Event"

    fill_in "End Date", with: @event.end_date
    fill_in "City", with: @event.city
    fill_in "Name", with: @event.name
    fill_in "Start Date", with: @event.start_date
    click_on "Create event"

    assert_text "Event was successfully created"
    click_on "Back"
  end

  test "updating a Event" do
    visit events_url
    click_on "Edit", match: :first

    fill_in "End Date", with: @event.end_date
    fill_in "City", with: @event.city
    fill_in "Name", with: @event.name
    fill_in "Start Date", with: @event.start_date
    click_on "Update Event"

    assert_text "Event was successfully updated"
    click_on "Back"
  end

  test "destroying a Event" do
    visit events_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Event was successfully destroyed"
  end
end
