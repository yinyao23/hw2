class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    # Part_2: filter by rating selections
    if params[:ratings] 
      @ratings_to_show = params[:ratings].keys
    # elsif session[:ratings]
    #   @ratings_to_show = session[:ratings]
    else
      @ratings_to_show = []
    end
    @movies = Movie.with_ratings(@ratings_to_show)
    
    # Part_1: sort by movie titles or release date
    sort_by = params[:sort] 
    sort_movies(sort_by) if sort_by != nil
    
    # Remeber settings in cookies
    # session[:ratings] = @ratings_to_show
    # session[:sort] = sort_by
  end
  
  def sort_movies(sort_by)
    @ratings_to_show = params[:selected_ratings]
    if sort_by == 'title'
      @movies, @title_class = Movie.with_ratings(params[:selected_ratings]).order(title: :asc), 'hilite bg-warning' 
    elsif sort_by == 'date'
      @movies, @date_class = Movie.with_ratings(params[:selected_ratings]).order(release_date: :asc), 'hilite bg-warning'
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
