class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirected = false
    if(session[:first] == nil)
      session[:first] = true
    end
    if params == {"action"=>"index", "controller"=>"movies"}
      if(!session[:first])
        redirect_to session[:return_to]
        redirected = true
      else
        session[:first] = false
        @movies = Movie.all
        params[:ratings] = {"G"=>"1", "PG"=>"1", "PG-13"=>"1", "R"=>"1", "NC-17"=>"1"}
      end
    end
    if params[:ratings].nil? && !redirected
      redirect_to session[:return_to]
    end
    session[:return_to] = request.url
    @sort = params[:sort]
    @movies = []
    @all_ratings = ["G", "PG", "PG-13", "R", "NC-17"]
    if !params[:ratings].nil?    
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

  def test
    redirect_to(:action => 'index')
  end

end
