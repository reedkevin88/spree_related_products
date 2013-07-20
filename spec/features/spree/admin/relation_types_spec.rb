require 'spec_helper'

feature "Manage Relation Types" do
  stub_authorization!

  background do
    %w(Benz BMW).each { |name| Spree::RelationType.create(name: name, applies_to: "Spree::Product") }

    visit spree.admin_path

    click_link "Configuration"
    click_link "Manage Relation Types"
  end

  context "create" do
    scenario "can create a new relation type" do
      click_link "New Relation Type"
      expect(current_path).to eql(spree.new_admin_relation_type_path)

      fill_in "Name", with: "bullock cart"
      fill_in "Applies To", with: "Spree:Products"

      click_button "Create"

      page.should have_content("successfully created!")

      expect(current_path).to eql(spree.admin_relation_types_path)
    end

    scenario "show validation errors with blank name" do
      click_link "New Relation Type"
      expect(current_path).to eql(spree.new_admin_relation_type_path)

      fill_in "Name", with: ""
      click_button "Create"

      page.should have_content("Name can't be blank")
    end

    scenario "show validation errors with blank applies_to" do
      click_link "New Relation Type"
      expect(current_path).to eql(spree.new_admin_relation_type_path)

      fill_in "Name", with: "Test"
      fill_in "Applies To", with: ""
      click_button "Create"

      page.should have_content("Applies To can't be blank")
    end

    scenario "should not create duplicate relation type" do
      relation_type_first  = Spree::RelationType.create(name: "My Test Type", applies_to: "Spree::Product")
      relation_type_second = Spree::RelationType.create(name: "My Test Type", applies_to: "Spree::Product")
      relation_type_second.should_not be_valid
    end
  end

  context "show" do
    scenario "display existing relation types" do
      within_row(1) do
        column_text(1).should == "Benz"
        column_text(2).should == "Spree::Product"
        column_text(3).should == ""
      end
    end
  end

  context "edit" do
    background do
      within_row(1) { click_icon :edit }
      expect(current_path).to eql(spree.edit_admin_relation_type_path(1))
    end

    scenario "allow an admin to edit an existing relation type" do
      fill_in "Name", with: "model 99"
      click_button "Update"
      page.should have_content("successfully updated!")
      page.should have_content("model 99")
    end

    scenario "show validation errors if there are any" do
      fill_in "Name", with: ""
      click_button "Update"
      page.should have_content("Name can't be blank")
    end
  end
end