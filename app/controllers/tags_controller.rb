class TagsController < ApplicationController
  
  def index 
    @tags = Bill.tag_counts(:order => 'name').paginate(:page => params[:page],
                      :per_page => 100)
  end
  
  def show 
    @bills = Bill.find_tagged_with(params[:id])
  end 
  
end
