class BasePublisherController < ApplicationController 
  before_filter :authenticate_user!, :except => ['show','index']
  layout "publishers"

end
