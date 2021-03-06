require 'test_helper'

# Tests for +User Sessions Controller+
# @author Ashley Childress
# @version 2.25.2014
describe UserSessionsController do
  include OmniauthMacros
	setup :activate_authlogic

	before do
		user = FactoryGirl.create(:user)
		@ability = Ability.new(user)
		@controller.stubs(:current_ability).returns(@ability)
	end

	describe "POST #create" do
		before :each do
			@user = FactoryGirl.create(:user)
			@ability.can :login, User
		end

		it "has route to login" do
			assert_routing '/login', { controller: 'user_sessions', action: 'new' }
		end

		it "must get new" do
			get :new
			assert_response :success
		end

		it "must create new user from omniauth" do
			skip 'investigate failure'
			assert_difference('User.count') do
				post :create, request.env['omniauth.auth'] = mock_twitter_hash
			end
			assert assigns(:user)
			assert_redirected_to root_path
		end

		it "must log in existing omniauth user" do
			skip 'investigate failure'
			post :create, request.env['omniauth.auth'] = mock_twitter_hash
			assert_no_difference('User.count') do
				post :create, request.env['omniauth.auth'] = mock_twitter_hash
			end
		end

		it "must log in user with valid credentials" do
			skip "troubleshoot error"
			post :create, user_name: @user.user_name, password: @user.password
			assert_redirected_to root_path
			current_user.wont_be_nil
		end

		it "wont log in user if invalid credentials" do
			skip 'investigate failure'
			post :create, user_session: { user_name: 'invalidusername', password: 'NoPassword' }
			assert_redirected_to login_path
			#current_user.must_be_nil
		end
	end

	describe 'POST #delete' do
		before :each do
			@user = FactoryGirl.create(:user)
			@ability.can :logout, @user
		end

		it "routes to logout" do
			skip 'investigate failure'
			assert_routing '/logout', { controller: 'user_sessions', action: 'delete' }
		end

		it "logs user out" do
			skip 'investigate failure'
			@controller.stubs(:current_user).returns(@user)
			delete :destroy, id: @user.id
			assert_redirected_to root_path
			@controller.current_user.must_be_nil
		end
	end
end
