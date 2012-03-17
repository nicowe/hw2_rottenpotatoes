class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # potentially redirects to make params contain all infos
    params_to_save = ['ratings', 'sort_by']
    update_params_with_session_params(params_to_save)

    @all_ratings = Movie.ratings
    @sort_by = params[:sort_by]
    if params[:ratings] == nil
      @ratings_to_display = @all_ratings
    else
      @ratings_to_display = params[:ratings].keys
    end

    @movies = Movie.where(:rating => @ratings_to_display).order(@sort_by)
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

  def update_params_with_session_params(params_to_save)
    # expects an iterable

    session.update(params.slice(*params_to_save))

    using_stored_params = false
    params_to_save.each do |param|
      if session.include? param and not params.include? param
        params[param] = session[param]
        using_stored_params = true
      end
    end

    if using_stored_params
      #keep RESTfulness
      redirect_to movies_path(params)
      return
    end
  end

end
