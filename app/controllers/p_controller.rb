class PController < ApplicationController
  layout "embed"
  def preview
 
    @course = Course.find(params[:id])
  end
end
