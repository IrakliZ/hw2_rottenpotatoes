class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = params[:sort]
    @movies = []
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    puts params[:sort]
    @ratings_list = ["G", "PG", "PG-13", "R", "NC-17"]
    if params[:ratings] == nil
      @movies = Movie.all
    else      
      Movie.all.each { |value| 
        if params[:ratings][value.rating] == "1"
          @movies << value
        end
      }
    end
    if @sort == "title"
      @movies.sort!{|a, b| a.title.downcase <=> b.title.downcase}
    elsif @sort == "date"
      @movies.sort!{|a, b| a.release_date <=> b.release_date}
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
