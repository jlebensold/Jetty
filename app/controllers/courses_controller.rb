class CoursesController < ApplicationController
  before_filter :authenticate_user!

  def list
      render :json => {:success => true, :courses => User.find(current_user.id).courses.as_json}
  end

  def saveorder
    params[:ordering].each { |k,v|
      CourseItem.find(v[:id].to_i).update_attributes({:ordering => v[:order]})
    }
    render :json => {:success => true}
  end
  def addcontent
    if (params[:course][:id] && params[:content][:id])
      @ci = CourseItem.new
      if (@ci.update_attributes(:course_id => params[:course][:id],
                                :content_id => params[:content][:id],
                                :ordering => params[:order]))
        render :json => {:success => true, :course_item => @ci.as_json }
        return
      end
    end
    render :json => {:success => false}
  end

  def deleteitem
    if (params[:courseitem][:id])
      CourseItem.find(params[:courseitem][:id]).delete
      render :json => {:success => true }
    else
      render :json => {:success => false}
    end
  end
  def delete
    if (params[:course][:id])
      Course.find(params[:course][:id]).delete
      render :json => {:success => true }
    else
      render :json => {:success => false}
    end
  end
  def saveitem
    if (params[:courseitem][:id])
      @courseitem = CourseItem.find(params[:courseitem][:id])

      if @courseitem.update_attributes(:amount => params[:courseitem][:amount],
                                       :monetize => params[:courseitem][:monetize])
        @courseitem.save!
        return render :json => {:success => true, :courseitem => @courseitem.as_json}
      end
    end
    render :json => {:success => false}
  end
  def save
    if (params[:course][:id])
      @course = Course.find(params[:course][:id])
    else
      @course = Course.new
    end
    @course.creator = User.find(current_user.id)
    if @course.update_attributes(params[:course])
      @course.save!
      render :json => {:success => true, :course => @course.as_json}
    else
      render :json => {:success => false}
    end
  end

  def index
    #redirect_to "/users"
  end
  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(params[:course])
      redirect_to "/users"
    end
  end
end
