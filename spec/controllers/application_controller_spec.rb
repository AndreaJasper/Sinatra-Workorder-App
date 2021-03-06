require 'spec_helper'

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Worder")
    end
  end

  describe "Signup Page" do

    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to workorder index' do
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include("/workorders")
    end

    it 'does not let a user sign up without a username' do
      params = {
        :username => "",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without an email' do
      params = {
        :username => "skittles123",
        :email => "",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a password' do
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a logged in user view the signup page' do
      #user = User.create(:username => "skittles123", :email => "skittles@aol.com", :password => "rainbows")
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      get '/signup'
      expect(last_response.location).to include('/workorders')
    end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the workorders index after login' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Current Workorders")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/login'
      expect(last_response.location).to include("/workorders")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in and redirects to the login page" do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")
    end

    it 'redirects a user to the index page if the user tries to access /logout while not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")

    end

    it 'redirects a user to the login route if a user tries to access /workorders route if user not logged in' do
      get '/workorders'
      expect(last_response.location).to include("/login")
      expect(last_response.status).to eq(302)
    end

    it 'loads /workorders if user is logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")


      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      expect(page.current_path).to eq('/workorders')
      expect(page.body).to include("Current Workorders")
    end
  end

  describe 'user show page' do
    it 'shows all a single users workorders' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      workorder1 = Workorder.create(:name => "workorders!", :user_id => user.id)
      workorder2 = Workorder.create(:name => "workorder workorder workorder", :user_id => user.id)
      get "/users/#{user.slug}"

      expect(last_response.body).to include("workorders!")
      expect(last_response.body).to include("workorder workorder workorder")

    end
  end

  describe 'index action' do
    fcontext 'logged in' do
      it 'lets a user view the workorders index if logged in' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        workorder1 = Workorder.create(:name => "workorders!", :user_id => user1.id)

        user2 = User.create(:username => "silver29", :email => "starz@aol.com", :password => "horses")
        workorder2 = Workorder.create(:name => "this is great!", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/workorders"
        expect(page.body).to include(workorder1.name)
        expect(page.body).to include(workorder2.name)
      end
    end

    context 'logged out' do
      it 'does not let a user view the workorders index if not logged in' do
        get '/workorders'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new workorder form if logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/workorders/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a workorder if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/workorders/new'
        fill_in(:name, :with => "workorders!!!")
        click_button 'submit'

        user = User.find_by(:username => "becky567")
        workorder = Workorder.find_by(:name => "workorders!!!")
        expect(workorder).to be_instance_of(Workorder)
        expect(workorder.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user workorder from another user' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/workorders/new'

        fill_in(:name, :with => "workorders!!!")
        click_button 'submit'

        user = User.find_by(:id=> user.id)
        user2 = User.find_by(:id => user2.id)
        workorder = Workorder.find_by(:name => "workorders!!!")
        expect(workorder).to be_instance_of(Workorder)
        expect(workorder.user_id).to eq(user.id)
        expect(workorder.user_id).not_to eq(user2.id)
      end

      it 'does not let a user create a blank workorder' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/workorders/new'

        fill_in(:name, :with => "")
        click_button 'submit'

        expect(Workorder.find_by(:name => "")).to eq(nil)
        expect(page.current_path).to eq("/workorders/new")
      end
    end

    context 'logged out' do
      it 'does not let user view new workorder form if not logged in' do
        get '/workorders/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single workorder' do

        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        workorder = Workorder.create(:name => "i am a boss at workorders", :user_id => user.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit "/workorders/#{workorder.id}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("Delete")
        expect(page.body).to include(workorder.name)
        expect(page.body).to include("Edit Workorder")
      end
    end

    context 'logged out' do
      it 'does not let a user view a workorder' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        workorder = Workorder.create(:name => "i am a boss at workorders", :user_id => user.id)
        get "/workorders/#{workorder.id}"
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view workorder edit form if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        workorder = Workorder.create(:name => "workorders!", :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/workorders/1/edit'
        expect(page.status_code).to eq(200)
        expect(page.body).to include(workorder.name)
      end

      it 'does not let a user edit a workorder they did not create' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        workorder1 = Workorder.create(:name => "workorders!", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        workorder2 = Workorder.create(:name => "look at this workorder", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "workorders/#{workorder2.id}"
        click_on "Edit Workorder"
        expect(page.status_code).to eq(200)
        expect(Workorder.find_by(:name => "look at this workorder")).to be_instance_of(Workorder)
        expect(page.current_path).to include('/workorders')
      end

      it 'lets a user edit their own workorder if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        workorder = Workorder.create(:name => "workorders!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/workorders/1/edit'

        fill_in(:name, :with => "john")
        fill_in(:description, :with => "i love workorders")
        fill_in(:hours_needed, :with => "8")

        click_button 'submit'
        # expect(Workorder.find_by(:name => "i love workorders")).to be_instance_of(Workorder)
        # expect(Workorder.find_by(:name => "workorders!")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a text with blank content' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        workorder = Workorder.create(:name => "workorders!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/workorders/1/edit'

        fill_in(:name, :with => "")
        fill_in(:description, :with => "")
        fill_in(:multiplier, :with => "")
        fill_in(:hours_needed, :with => "")

        click_button 'submit'
        expect(Workorder.find_by(:name => "i love workorders")).to be(nil)
        expect(page.current_path).to eq("/workorders/1/edit")
      end
    end

    context "logged out" do
      it 'does not load -- requests user to login' do
        get '/workorders/1/edit'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own workorder if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        workorder = Workorder.create(:name => "workorders!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit 'workorders/1'
        click_button "Delete"
        expect(page.status_code).to eq(200)
        expect(Workorder.find_by(:name => "workorders!")).to eq(nil)
      end

      it 'does not let a user delete a workorder they did not create' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        workorder1 = Workorder.create(:name => "workorders!", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        workorder2 = Workorder.create(:name => "look at this workorder", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "workorders/#{workorder2.id}"
        click_button "Delete"
        expect(page.status_code).to eq(200)
        expect(Workorder.find_by(:name => "look at this workorder")).to be_instance_of(Workorder)
        expect(page.current_path).to include('/workorders')
      end
    end

    context "logged out" do
      it 'does not load let user delete a workorder if not logged in' do
        workorder = Workorder.create(:name => "workorder!", :user_id => 1)
        visit '/workorders/1'
        expect(page.current_path).to eq("/login")
      end
    end
  end
end