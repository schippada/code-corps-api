class AddDescriptionToOrganizations < ActiveRecord::Migration
  def change
    add_column(:organizations, :description, :text)
  end
end
