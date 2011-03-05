class CoursesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @course = Course.new
    @course.creator = User.find(current_user.id)
    @course.save!
  end
  def index
    redirect_to "/users"
  end
  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(params[:course])
      redirect_to "/users"
    end
  end
  def edit
    @course = Course.find(params[:id])
  end

  def show
    @course = Course.find(params[:id])
  end
  
  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    redirect_to "/users"
  end

end
