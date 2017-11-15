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
    my_params = params.permit(:column, :ratings)
    sort_col = ""
    @title_sty = nil
    @date_sty = nil
    @all_ratings = Movie.get_ratings
    @checked = params[:ratings]
    puts @checked
   
    
    if my_params[:column]
      sort_col = my_params[:column]
    end
    
    if sort_col == 'title'
      @title_sty = 'hilite'
    end
    
    if sort_col == 'release_date'
      @date_sty = 'hilite'
    end
    
    if params[:ratings]
      puts "Have some filters"
      @movies = Movie.where(:rating => params[:ratings].keys)
    else  
      @movies = Movie.all.order(sort_col)
    end
   
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
