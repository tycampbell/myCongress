class TagsController < ApplicationController
  
  def index 
    @tags = Bill.tag_counts(:order => 'name').paginate(:page => params[:page],
                      :per_page => 100)
  end
  
  def show 
    all_bills = Bill.find_tagged_with(params[:id], :order => 'finished_at DESC')
    summarized_bills = []
    new_bills = []
    finished_bills = []
    all_bills.each do |bill|
      if bill.summarized && !bill.finished
        summarized_bills << bill
      elsif bill.finished
        finished_bills << bill
      else
        new_bills << bill
      end
    end
    
    summarized_bills.sort!{|a,b| a.summarized_at <=> b.summarized_at }
    new_bills.sort!{|a,b| a.created_at <=> b.created_at }
    
    #Sort by finished_at in the find method because most bills will be finished
    #finished_bills.sort!{|a,b| a.finished_at <=> b.finished_at }
    
    #SORT tagged bills by summarized, then new, then finished
    @bills = summarized_bills + new_bills + finished_bills
  end 
  
end
