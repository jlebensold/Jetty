class PController < ApplicationController
  layout "embed"
  def contentbox
    @course = CourseItem.find(params[:id])
    if(@course.purchased_or_free(current_user))
      render :json => { 
        :subcontents => get_subcontents(@course.content),
        :references => @course.content.references.as_json,
        :contentboxhtml => render_to_string(:partial=> "shared/contentbox",:locals => {:content => @course.content})}
    else
      render :json => {:contentboxhtml => "<div>not permitted</div>"}
    end    
  end
  def course
    render :json => Course.find(params[:id]).as_jsonpreview(current_user)
  end
  def courselist
    @course = Course.find(params[:id])
    render :json => @course.course_items.map{|c| c.as_jsonpreview(current_user) }
  end
  def purchases
    payments = Payment.where({:user_id => current_user.id}).group_by(&:purchaseable_type)
    render :json => [payments["Course"] ,payments["Content"] ]
  end
  def preview
    #headers['X-Frame-Options'] = "GOFORIT"
    @course = Course.find(params[:id])
  end
  private
  def get_subcontents c
    c.subcontents.map { |i| i.as_json({:contentboxhtml => render_to_string(:partial=> "shared/contentbox",
                                                       :locals => {:content => i} ) }) }
  end

end
