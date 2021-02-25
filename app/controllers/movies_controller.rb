class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    @all_ratings = Movie.all_ratings
    @ratings_to_show = []
    sort_by = nil
      
    if params[:commit]
      @ratings_to_show = params[:ratings].keys if params[:ratings]
    elsif params[:sort]
      @ratings_to_show = params[:selected_ratings] if params[:selected_ratings]
      sort_by = params[:sort]
    elsif session[:ratings] or session[:sort]
      @ratings_to_show = session[:ratings]
      sort_by = session[:sort]
    end
    
    @movies = Movie.with_ratings(@ratings_to_show)
    sort_movies(sort_by) if sort_by != nil
    
    # Remeber settings in cookies
    session[:ratings] = @ratings_to_show
    session[:sort] = sort_by
  end
  
  def sort_movies(sort_by)
    if sort_by == 'title'
      @movies, @title_class = @movies.order(title: :asc), 'hilite bg-warning' 
    elsif sort_by == 'date'
      @movies, @date_class = @movies.order(release_date: :asc), 'hilite bg-warning'
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
