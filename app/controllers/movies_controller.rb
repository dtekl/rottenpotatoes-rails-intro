class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    params.permit(:column, :ratings)
    sort_col = ""
    @title_sty = nil
    @date_sty = nil
    @all_ratings = Movie.get_ratings
    
    ###############
    #check first what's come in from params
    #if if no column, then fill with session (if session)
    #if param[:ratings]
    #if session[:ratings] = param[:ratings] do nothing
    #if !session[:ratings] or session[:ratings] != paraa [:ratings]
    #session[:ratings] = param[:ratings].
    
    #first check if no params[:column] and params[:ratings]
    #set vars from session and redirect with session params
    
    col_param = params[:column]
    ratings_param = params[:ratings]
    col_session = session[:column]
    ratings_session = session[:ratings]
    if !ratings_session or (!params[:ratings]  and params[:commit] == "Refresh")
      ratings_session = {}
      Movie.get_ratings.each {|s| ratings_session[s] = 1}
      session[:ratings] = ratings_session
    end
    
    if !col_session
      col_session = ''
      session[:column] = ''
    end
   
    
    if !col_param and !ratings_param #redirect with params just whats in the session
      flash.keep
      redirect_to movies_path(:column => col_session, :ratings => ratings_session) and return
    end
    
    if !ratings_param #i.e. no ratings parameter passed so use session 
      session[:ratings] = ratings_param
      ratings = ratings_session
      flash.keep
      redirect_to movies_path(:column => col_param, :ratings => ratings) and return
    end
    
    if !col_param #i.e. no column parameter passed so use session
      session[:column] = col_param
      
      sort_col = col_session
      ratings = ratings_param
      flash.keep
      redirect_to movies_path(:column => sort_col, :ratings => ratings) and return
    end
      
  
   if col_param and ratings_param
     session[:column] = col_param
     session[:ratings] = ratings_param
   end
    
    if col_param
      sort_col = params[:column]
    end
    
    if sort_col == 'title'
      @title_sty = 'hilite'
    end
    
    if sort_col == 'release_date'
      @date_sty = 'hilite'
    end
    
   
     
    @movies = Movie.where(:rating => ratings_param.keys).order(sort_col)
    
   
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
