require 'test_helper'

class AttendeesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::ControllerHelpers

  setup do
    sign_in users(:admin)
    @event = events(:one)
    @attendee = attendees(:one)
  end

  test "should get attendees index" do
    get event_attendees_url(@event)
    assert_response :success
  end

  test "should get attendees new" do
    get new_event_attendee_path(@event)
    assert_response :success
  end

  test "should create attendee" do
    assert_difference('Attendee.count') do
      post event_attendees_url(@event), params: { attendee: { first_name: @attendee.first_name, last_name: @attendee.last_name, email: @attendee.email, event_id: @attendee.event_id } }
    end

    assert_redirected_to event_attendee_url(@event, Attendee.last)
  end

  test "should show attendee" do
    get event_attendee_url(@event, @attendee)
    assert_response :success
  end

  test "should get attendee edit" do
    get edit_event_attendee_url(@event, @attendee)
    assert_response :success
  end

  test "should update attendee" do
    patch event_attendee_url(@event, @attendee), params: { attendee: { first_name: @attendee.first_name, last_name: @attendee.last_name, email: @attendee.email, event_id: @attendee.event_id } }
    assert_redirected_to event_attendee_url(@event, @attendee)
  end

  test "should destroy attendee" do
    assert_difference('Attendee.count', -1) do
      delete event_attendee_url(@event, @attendee)
    end

    assert_redirected_to event_attendees_url
  end
end
