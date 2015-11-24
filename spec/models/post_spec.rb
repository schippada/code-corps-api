require 'rails_helper'

describe Post, :type => :model do
  describe "schema" do
    it { should have_db_column(:status).of_type(:string) }
    it { should have_db_column(:type).of_type(:string) }
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:body).of_type(:text) }
    it { should have_db_column(:project_id).of_type(:integer) }
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:updated_at) }
    it { should have_db_column(:created_at) }
  end

  describe "relationships" do
    it { should have_many(:comments) }
    it { should belong_to(:project) }
    it { should belong_to(:user) }
  end

  describe "behavior" do
    it { should define_enum_for(:status).with({ open: "open", closed: "closed" }) }
    it { should define_enum_for(:type).with({ idea: "idea", progress: "progress", task: "task", issue: "issue" }) }
  end
end
