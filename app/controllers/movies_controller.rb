class MoviesController < ApplicationController
 helper_method :ratings_filter, :sort_column, :sort_order
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
      # part 3
    redirect = 0
    if params[:ratings] != ratings_filter
        redirect = 1
    end
    
    if session[:ratings] != ratings_filter
        session[:ratings] = ratings_filter
    end
    if session[:sort] != sort_column
        session[:sort] = sort_column
    end
    
    if redirect==1
        flash.keep
        redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
        else
        @all_ratings = Movie.ratings
        @movies = Movie.conditions_orders params[:ratings].keys, sort_column
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
  # part1&2
  def sort_column
      Movie.column_names.include?(params[:sort]) ? params[:sort] : session[:sort]
  end

  def sort_order
      %w[asc desc].include?(params[:direction]) ?  "asc" : "desc"
  end
  
  def ratings_filter
      if params[:ratings]
          params[:ratings]
          elsif !session[:ratings]
          Hash[Movie.ratings.map { |x| [x, 1] }]
          else
          session[:ratings]
      end
  end

end
