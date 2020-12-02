require "rails_helper"

RSpec.feature "SmartAnswer::BusinessCoronavirusSupportFinderFlow", type: :feature do
  let(:headings) do
    # <question name>: <text_for :title from erb>
    {
      flow_title: "Find coronavirus financial support for your business",
      annual_turnover: "What is your annual turnover?",
      business_based: "Where is your business based?",
      business_size: "How many employees does your business have?",
      non_domestic_property: "What is the rateable value of your business' non-domestic property?",
      paye_scheme: "Are you an employer with a PAYE scheme?",
      rate_relief_march_2020: "Is your business in receipt of small business rate relief or rural rate relief as of 11 March 2020?",
      sectors: "Is your business in any of the following sectors:",
      self_assessment_july_2020: "Are you due to pay a Self Assessment payment on account by 31 July 2020?",
      self_employed: "Are you self-employed?",
      what_size_was_your_buisness: "What size was your business as of 28 February?",
      where_is_your_business_based: "Where is your business based?",
      results: "Support you may be entitled to",
    }
  end

  before do
    stub_content_store_has_item("/business-coronavirus-support-finder")
  end

  # Only the non_domestic_property question causes a flow path change.
  # For all other questions, any of the available answers would result in the same next page.
  scenario "Answers for business that does not have non domestic property" do
    visit "/business-coronavirus-support-finder"

    expect(page).to have_selector("h1", text: headings[:results])
    expect(page).to have_selector("span.govuk-caption-xl", text: headings[:flow_title])

    click_govuk_start_button
    expect(page).to have_selector("h1", text: headings[:business_based])

    choose "England"
    click_button "Next step"
    expect(page).to have_selector("h1", text: headings[:business_size])

    choose "0 to 249 employees"
    click_button "Next step"
    expect(page).to have_selector("h1", text: headings[:annual_turnover])

    choose "My business is a start-up and is pre-revenue"
    click_button "Next step"
    expect(page).to have_selector("h1", text: headings[:paye_scheme])

    choose "Yes"
    click_button "Next step"
    expect(page).to have_selector("h1", text: headings[:self_employed])

    choose "Yes"
    click_button "Next step"
    expect(page).to have_selector("h1", text: headings[:non_domestic_property])

    choose "My business does not have any non-domestic property"
    click_button "Next step"
    expect(page).to have_selector("h1", text: headings[:flow_title])
    expect(page).to have_selector("h2", text: headings[:results])
  end

  scenario "Answers for business that has non domestic property" do
    visit "/business-coronavirus-support-finder"
    expect(page).to have_selector("h1", text: headings[:flow_title])

    click_govuk_start_button
    expect(page).to have_selector("h1", text: headings[:business_based])

    choose "England"
    click_button "Next step"
    expect(page).to have_selector("h1", text: headings[:business_size])

    choose "0 to 249 employees"
    click_button "Next step"
    expect(page).to have_selector("h1", text: headings[:annual_turnover])

    choose "My business is a start-up and is pre-revenue"
    click_button "Next step"
    expect(page).to have_selector("h1", text: headings[:paye_scheme])

    choose "Yes"
    click_button "Next step"
    expect(page).to have_selector("h1", text: headings[:self_employed])

    choose "Yes"
    click_button "Next step"
    expect(page).to have_selector("h1", text: headings[:non_domestic_property])

    choose "Under £51,000"
    click_button "Next step"
    expect(page).to have_selector("h1", text: headings[:sectors])

    check "Nurseries"
    click_button "Next step"
    expect(page).to have_selector("h1", text: headings[:rate_relief_march_2020])

    choose "Yes"
    click_button "Next step"
    expect(page).to have_selector("h1", text: headings[:flow_title])
    expect(page).to have_selector("h2", text: headings[:results])
  end
end
