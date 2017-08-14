require "rails_helper"

describe "navigation" do
  it "highlights the link to the current page's resource type" do
    visit admin_customers_path

    active_link = find(".navigation__link--active")

    expect(active_link.text).to eq "Customers"
  end

  it "displays translated name of model" do
    translations = {
      activerecord: {
        models: {
          customer: {
            one: "User",
            other: "Users",
          },
        },
      },
    }

    with_translations(:en, translations) do
      visit admin_customers_path

      navigation = find(".navigation")
      expect(navigation).to have_link("Users")
      expect(page).to have_header("Users")
    end
  end

  it "excludes resources with no index action" do
    begin
      Rails.application.routes.draw do
        namespace(:admin) do
          resources :customers
          resources :line_items, only: [:show]
        end
      end

      visit admin_customers_path

      navigation = find(".navigation")
      expect(navigation).not_to have_link("Line Items")
    ensure
      reset_routes
    end
  end
end
