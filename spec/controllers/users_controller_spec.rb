require 'rails_helper'

describe UsersController, type: :controller do
  let(:user) { create :user, location: 'Shanghai' }
  let(:deleted_user) { create :user, state: User.states[:deleted] }

  describe 'Visit deleted user' do
    it 'should 404 with deleted user' do
      get :show, params: { id: deleted_user.username }
      expect(response.status).to eq(404)
      get :topics, params: { id: deleted_user.username }
      expect(response.status).to eq(404)
    end
  end

  describe ':index' do
    it 'should have an index action' do
      get :index
      expect(response).to be_success
    end
  end

  describe ':show' do
    it 'should show user' do
      get :show, params: { id: user.username }
      expect(response).to be_success
    end
  end

  describe ':topics' do
    it 'should show user topics' do
      get :topics, params: { id: user.username }
      expect(response).to be_success
    end

    it 'should redirect to right spell login' do
      get :topics, params: { id: user.username.upcase }
      expect(response.status).to eq(301)
    end
  end

  describe ':replies' do
    it 'should show user replies' do
      get :replies, params: { id: user.username }
      expect(response).to be_success
    end
  end

  describe ':favorites' do
    it 'should show user liked stuffs' do
      get :favorites, params: { id: user.username }
      expect(response).to be_success
    end
  end

  describe ':block' do
    it 'should work' do
      sign_in user
      get :block, params: { id: user.username }
      expect(response).to be_success
    end
  end

  describe ':unblock' do
    it 'should work' do
      sign_in user
      get :unblock, params: { id: user.username }
      expect(response).to be_success
    end
  end

  describe ':blocked' do
    it 'should work' do
      sign_in user
      get :blocked, params: { id: user.username }
      expect(response).to be_success
    end

    it 'render 404 for wrong user' do
      user2 = create(:user)
      sign_in user
      get :blocked, params: { id: user2.login }
      expect(response.status).to eq 404
    end
  end

  describe ':follow' do
    it 'should work' do
      sign_in user
      get :follow, params: { id: user.username }
      expect(response).to be_success
    end
  end

  describe ':unfollow' do
    it 'should work' do
      sign_in user
      get :unfollow, params: { id: user.username }
      expect(response).to be_success
    end
  end

  describe ':followers' do
    it 'should work' do
      get :followers, params: { id: user.username }
      expect(response).to be_success
    end
  end

  describe ':following' do
    it 'should work' do
      get :following, params: { id: user.username }
      expect(response).to be_success
    end
  end

  describe ':city' do
    it 'should render 404 if there is no user in that city' do
      get :city, params: { id: 'Mars' }
      expect(response).not_to be_success
      expect(response.status).to eq(404)
    end

    it 'should show user associated with that city' do
      get :city, params: { id: user.location }
      expect(response.status).to eq(200)
    end
  end

  describe ':calendar' do
    it 'should work' do
      get :calendar, params: { id: user.username }
      expect(response.status).to eq(200)
    end
  end
end
