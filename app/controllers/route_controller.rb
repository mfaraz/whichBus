class RouteController < ApplicationController
  def index
     @routes = Route.all
  end
  
  def showAllRoute
    @routes = Route.all
  end
  
  def deleteRoute
  end
  
  def editRoute
  end
  
  def addRoute
    
    @routes = Route.new
    
  end
  
  def createRoute    
    
    @route = Route.new(params[:route].permit(:routeName, :routeDistance, :user_id))
    
    if @route.save
      redirect_to :action => 'showAllRoute' 
    else
      render 'addRoute'
    end
    
  end
  
  def showRaute
    
    @routes = Route.find(params [:id])
    
  end
end
