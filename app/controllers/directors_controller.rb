class DirectorsController < ApplicationController
  def index
    matching_directors = Director.all

    @list_of_directors = matching_directors.order({ :created_at => :desc })

    render({ :template => "directors/index.html.erb" })
  end

  def max_dob
    directors_by_dob_desc = Director.
      all.
      where.not({ :dob => nil }).
      order({ :dob => :desc })

    @youngest = directors_by_dob_desc.at(0)

    render({ :template => "directors/youngest" })
  end

  def min_dob
    directors_by_dob_asc = Director.
      all.
      where.not({ :dob => nil }).
      order({ :dob => :asc })
      
    @eldest = directors_by_dob_asc.at(0)

    render({ :template => "directors/eldest" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_directors = Director.where({ :id => the_id })

    @the_director = matching_directors.at(0)

    render({ :template => "directors/show.html.erb" })
  end

  def create
    the_director = Director.new
    the_director.name = params.fetch("query_name")
    the_director.dob = params.fetch("query_dob")
    the_director.bio = params.fetch("query_bio")
    the_director.image = params.fetch("query_image")

    if the_director.valid?
      the_director.save
      redirect_to("/directors", { :notice => "Director created successfully." })
    else
      redirect_to("/directors", { :notice => "Director failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_director = Director.where({ :id => the_id }).at(0)

    the_director.name = params.fetch("query_name")
    the_director.dob = params.fetch("query_dob")
    the_director.bio = params.fetch("query_bio")
    the_director.image = params.fetch("query_image")

    if the_director.valid?
      the_director.save
      redirect_to("/directors/#{the_director.id}", { :notice => "Director updated successfully."} )
    else
      redirect_to("/directors/#{the_director.id}", { :alert => "Director failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_director = Director.where({ :id => the_id }).at(0)

    the_director.destroy

    redirect_to("/directors", { :notice => "Director deleted successfully."} )
  end
end
