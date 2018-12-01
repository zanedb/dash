require "application_system_test_case"

class HardwaresTest < ApplicationSystemTestCase
  setup do
    @hardware = hardwares(:one)
  end

  test "visiting the index" do
    visit hardwares_url
    assert_selector "h1", text: "Hardwares"
  end

  test "creating a Hardware" do
    visit hardwares_url
    click_on "New Hardware"

    fill_in "Barcode", with: @hardware.barcode
    fill_in "Checked Out At", with: @hardware.checked_out_at
    fill_in "Checked Out By", with: @hardware.checked_out_by
    fill_in "Checked Out To", with: @hardware.checked_out_to
    fill_in "Model", with: @hardware.model
    fill_in "Vendor", with: @hardware.vendor
    click_on "Create Hardware"

    assert_text "Hardware was successfully created"
    click_on "Back"
  end

  test "updating a Hardware" do
    visit hardwares_url
    click_on "Edit", match: :first

    fill_in "Barcode", with: @hardware.barcode
    fill_in "Checked Out At", with: @hardware.checked_out_at
    fill_in "Checked Out By", with: @hardware.checked_out_by
    fill_in "Checked Out To", with: @hardware.checked_out_to
    fill_in "Model", with: @hardware.model
    fill_in "Vendor", with: @hardware.vendor
    click_on "Update Hardware"

    assert_text "Hardware was successfully updated"
    click_on "Back"
  end

  test "destroying a Hardware" do
    visit hardwares_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hardware was successfully destroyed"
  end
end
