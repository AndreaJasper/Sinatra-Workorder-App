require 'spec_helper'

describe "Homepage" do
    it 'loads the homepage' do
        get '/'
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Welcome to Work Order Management")
    end
end

describe "Signup Page" do

    it 'loads the signup page' do
        get '/signup'
        expect(last_response.status).to eq(200) 
    end

    it "signup directs user to workorder index" do
        params = {
            :username => "awesomeemployee1234",
            :email => "awesome@aol.com",
            :password => "employee"
        }
        post '/signup', params
      expect(last_response.location).to include("/workorders")
    end
    
    it 'does not let a user sign up without a username' do
        params = {
            :username => "",
            :email => "awesome@aol.com",
            :password => "employee"
        }
        post '/signup', params
        expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a email' do
        params = {
            :username => "awesomeemployee1234",
            :email => "",
            :password => "employee"
        }
        post '/signup', params
        expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a password' do
        params = {
            :username => "awesomeemployee1234",
            :email => "awesome@aol.com",
            :password => ""
        }
        post '/signup', params
        expect(last_response.location).to include('/signup')
    end

    it 'does not let a logged in user view the signup page' do
        params = {
            :username => "awesomeemployee1234",
            :email => "awesome@aol.com",
            :password => "employee"
        }
        post '/signup', params
        get '/signup'
        expect(last_response.location).to include("/workorders")
    end
end

describe "login" do
    it 'loads the login page' do
        get '/login'
        expect(last_response.status).to eq(200)
    end

    it 'loads the workorder index after login' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        params = {
          :username => "becky567",
          :password => "kittens"
        }
        post '/login', params
        expect(last_response.status).to eq(302)
        follow_redirect!
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Welcome,")
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
    
        it 'redirects a user to the login route if a user tries to access /workorder route if user not logged in' do
          get '/workorders'
          expect(last_response.location).to include("/login")
          expect(last_response.status).to eq(302)
        end
    
        it 'loads /workorders if user is logged in' do
          user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
    
    
          visit '/login'
    
          fill_in(:username, :with => "becky567")
          fill_in(:password, :with => "kittens")
          click_button 'Login'
          expect(page.current_path).to eq('/workorders')
          expect(page.body).to include("Welcome")
        end 
      end

      describe 'user show page' do
        it 'shows all a single users workorders' do
          user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
          workorder1 = Workorder.create(:name => "Filler", :user_id => user.id)
          workorder2 = Workorder.create(:name => "Filler 2", :user_id => user.id)
          get "/users/#{user.slug}"
    
          expect(last_response.body).to include("workorder!")
          expect(last_response.body).to include("workorder workorder workorder")
    
        end
      end

      describe 'index action' do
        context 'logged in' do
          it 'lets a user view the workorder index if logged in' do
            user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
            workorder1 = Workorder.create(:name => "workorder!", :user_id => user1.id)
    
            user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
            workorder2 = Workorder.create(:name => "look at this workorder", :user_id => user2.id)
    
            visit '/login'
    
            fill_in(:username, :with => "becky567")
            fill_in(:password, :with => "kittens")
            click_button 'Login'
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


      #=====

      describe 'new action' do
        context 'logged in' do
          it 'lets user view new workorder form if logged in' do
            user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
    
            visit '/login'
    
            fill_in(:username, :with => "becky567")
            fill_in(:password, :with => "kittens")
            click_button 'Login'
            visit '/workorders/new'
            expect(page.status_code).to eq(200)
          end
    
          it 'lets user create a workorder if they are logged in' do
            user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
    
            visit '/login'
    
            fill_in(:username, :with => "becky567")
            fill_in(:password, :with => "kittens")
            click_button 'Login'
    
            visit '/workorders/new'
            fill_in(:name, :with => "workorder!!!")
            click_button 'Submit Workorder'
    
            user = User.find_by(:username => "becky567")
            workorder = Workorder.find_by(:name => "workorder!!!")
            expect(workorder).to be_instance_of(workorder)
            expect(workorder.user_id).to eq(user.id)
            expect(page.status_code).to eq(200)
          end
    
          it 'does not let a user change a workorder from another user' do
            user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
            user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
    
            visit '/login'
    
            fill_in(:username, :with => "becky567")
            fill_in(:password, :with => "kittens")
            click_button 'Login'
    
            visit '/workorders/new'
    
            fill_in(:name, :with => "workorder!!!")
            click_button 'Submit Workorder'
    
            user = User.find_by(:id=> user.id)
            user2 = User.find_by(:id => user2.id)
            workorder = workorder.find_by(:name => "workorder!!!")
            expect(workorder).to be_instance_of(workorder)
            expect(workorder.user_id).to eq(user.id)
            expect(workorder.user_id).not_to eq(user2.id)
          end
    
          it 'does not let a user create a blank workorder' do
            user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
    
            visit '/login'
    
            fill_in(:username, :with => "becky567")
            fill_in(:password, :with => "kittens")
            click_button 'Login'
    
            visit '/workorders/new'
    
            fill_in(:name, :with => "")
            click_button 'Submit Workorder'
    
            expect(workorder.find_by(:name => "")).to eq(nil)
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
            workorder = Workorder.create(:name => "i am a boss at building workorders", :user_id => user.id)
    
            visit '/login'
    
            fill_in(:username, :with => "becky567")
            fill_in(:password, :with => "kittens")
            click_button 'Login'
    
            visit "/workorders/#{workorder.id}"
            expect(page.status_code).to eq(200)
            expect(page.body).to include("Delete Workorder")
            expect(page.body).to include(workorder.name)
            expect(page.body).to include("Edit Workorder")
          end
        end
    
        context 'logged out' do
          it 'does not let a user view a workorder' do
            user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
            workorder = Workorder.create(:name => "i am a boss at creating workorders", :user_id => user.id)
            get "/workorders/#{workorder.id}"
            expect(last_response.location).to include("/login")
          end
        end
      end
    
      describe 'edit action' do
        context "logged in" do
          it 'lets a user view workorder edit form if they are logged in' do
            user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
            workorder = Workorder.create(:name => "Submit Workorder", :user_id => user.id)
            visit '/login'
    
            fill_in(:username, :with => "becky567")
            fill_in(:password, :with => "kittens")
            click_button 'Login'
            visit '/workorders/1/edit'
            expect(page.status_code).to eq(200)
            expect(page.body).to include(workorder.name)
          end
    
          it 'does not let a user edit a workorder they did not create' do
            user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
            workorder1 = Workorder.create(:name => "Submit Workorder", :user_id => user1.id)
    
            user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
            workorder2 = Workorder.create(:name => "look at this workorder", :user_id => user2.id)
    
            visit '/login'
    
            fill_in(:username, :with => "becky567")
            fill_in(:password, :with => "kittens")
            click_button 'Login'
            visit "workorders/#{workorder2.id}"
            click_on "Update Workorder"
            expect(page.status_code).to eq(200)
            expect(workorder.find_by(:name => "look at this workorder")).to be_instance_of(workorder)
            expect(page.current_path).to include('/workorders')
          end
    
          it 'lets a user edit their own workorder if they are logged in' do
            user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
            workorder = Workorder.create(:name => "Submit Workorder", :user_id => 1)
            visit '/login'
    
            fill_in(:username, :with => "becky567")
            fill_in(:password, :with => "kittens")
            click_button 'Login'
            visit '/workorders/1/edit'
    
            fill_in(:name, :with => "i love workorders")
    
            click_button 'submit'
            expect(workorder.find_by(:name => "i love workorders")).to be_instance_of(workorder)
            expect(workorder.find_by(:name => "workorders!")).to eq(nil)
            expect(page.status_code).to eq(200)
          end
    
          it 'does not let a user edit a text with blank name' do
            user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
            workorder = Workorder.create(:name => "Submit Workorder", :user_id => 1)
            visit '/login'
    
            fill_in(:username, :with => "becky567")
            fill_in(:password, :with => "kittens")
            click_button 'Login'
            visit '/workorders/1/edit'
    
            fill_in(:name, :with => "")
    
            click_button 'Update Workorder'
            expect(workorder.find_by(:name => "i love workorders")).to be(nil)
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
            workorder = Workorder.create(:name => "Submit Workorder", :user_id => 1)
            visit '/login'
    
            fill_in(:username, :with => "becky567")
            fill_in(:password, :with => "kittens")
            click_button 'Log Out'
            visit 'workorders/1'
            click_button "Delete workorder"
            expect(page.status_code).to eq(200)
            expect(workorder.find_by(:name => "Submit Workorder")).to eq(nil)
          end
    
          it 'does not let a user delete a workorder they did not create' do
            user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
            workorder1 = Workorder.create(:name => "Submit Workorder", :user_id => user1.id)
    
            user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
            workorder2 = Workorder.create(:name => "look at this workorder", :user_id => user2.id)
    
            visit '/login'
    
            fill_in(:username, :with => "becky567")
            fill_in(:password, :with => "kittens")
            click_button 'Login'
            visit "workorders/#{workorder2.id}"
            click_button "Delete Workorder"
            expect(page.status_code).to eq(200)
            expect(workorder.find_by(:name => "look at this workorder")).to be_instance_of(workorder)
            expect(page.current_path).to include('/workorders')
          end
        end
    
        context "logged out" do
          it 'does not let user delete a workorder if not logged in' do
            workorder = Workorder.create(:name => "Submit Workorder", :user_id => 1)
            visit '/workorders/1'
            expect(page.current_path).to eq("/login")
          end
        end
      end


