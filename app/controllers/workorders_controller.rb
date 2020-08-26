class WorkordersController < ApplicationController
    get '/workorders' do
      if logged_in?
        @workorders = Workorder.all
        erb :'workorders/workorders'
      else
        redirect to '/login'
      end
    end
    
    get '/workorders/new' do
      if logged_in?
        erb :'workorders/create_workorder'
      else
        redirect to '/login'
      end
    end
    
    post '/workorders' do
      if logged_in?
        if params[:description] == ""
          redirect to "/workorders/new"
        else
          @workorder = current_user.workorders.build(name: params[:name], description: params[:description], multiplier: params[:multiplier])
          if @workorder.save
            redirect to "/workorders/#{@workorder.id}"
          else
            redirect to "/workorders/new"
          end
        end
      else
        redirect to '/login'
      end
    end
    
    get '/workorders/:id' do
      if logged_in?
        @workorder = Workorder.find_by_id(params[:id])
        erb :'workorders/show_workorder'
      else
        redirect to '/login'
      end 
    end 
    
    get '/workorders/:id/edit' do
      if logged_in?
        @workorder = Workorder.find_by_id(params[:id])
        if @workorder && @workorder.user == current_user
          erb :'workorders/edit_workorder'
        else
          redirect to '/workorders'
        end
      else
        redirect to '/login'
      end  
    end
    
    patch '/workorders/:id' do
      if logged_in?
        if params[:description] == ""
          redirect to "/workorders/#{params[:id]}/edit"
        else
          @workorder = Workorder.find_by_id(params[:id])
          if @workorder && @workorder.user == current_user
            if @workorder.update(name: params[:name], description: params[:description], hours_needed: params[:hours_needed]) 
              redirect to "/workorders/#{@workorder.id}"
            else
              redirect to "/workorders/#{@workorder.id}/edit"
            end
          else
            redirect to "/workorders"
          end
        end
      else
        redirect to "/login"
      end
    end
    
    delete '/workorders/:id/delete' do
      if logged_in? 
        @workorder = Workorder.find_by_id(params[:id])
        if @workorder && @workorder.user == current_user
          @workorder.delete
        end
        redirect to '/workorders'
      else
        redirect to '/login'
      end
    end
  end