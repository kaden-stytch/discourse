# frozen_string_literal: true

RSpec.describe Admin::VersionsController do

  before do
    Jobs::VersionCheck.any_instance.stubs(:execute).returns(true)
    DiscourseUpdates.stubs(:updated_at).returns(2.hours.ago)
    DiscourseUpdates.stubs(:latest_version).returns('1.2.33')
    DiscourseUpdates.stubs(:critical_updates_available?).returns(false)
  end

  it "is a subclass of StaffController" do
    expect(Admin::VersionsController < Admin::StaffController).to eq(true)
  end

  context 'while logged in as an admin' do
    fab!(:admin) { Fabricate(:admin) }
    before do
      sign_in(admin)
    end

    describe 'show' do
      it 'should return the currently available version' do
        get "/admin/version_check.json"
        expect(response.status).to eq(200)
        json = response.parsed_body
        expect(json['latest_version']).to eq('1.2.33')
      end

      it "should return the installed version" do
        get "/admin/version_check.json"
        json = response.parsed_body
        expect(response.status).to eq(200)
        expect(json['installed_version']).to eq(Discourse::VERSION::STRING)
      end
    end
  end
end
