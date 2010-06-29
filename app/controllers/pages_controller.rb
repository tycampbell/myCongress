class PagesController < ApplicationController
  
  before_filter :check_administrator_role, :except => :show
  
  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    #Since we use permalinks for show,
    #We find the first page matching the permalink
    @page = Page.find(:first, :conditions => ["permalink = ?", params[:id].to_s])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(:first, :conditions => ["permalink = ?", params[:id].to_s])
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])
    
    #automatically generate a permalink if none given
    if @page.permalink == ''
      @page.permalink = title.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
    else
      @page.permalink = @page.permalink.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
    end

    respond_to do |format|
      if @page.save
        flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to(page_url(@page.permalink)) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find(:first, :conditions => ["permalink = ?", params[:id].to_s])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to(page_url(@page.permalink)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(:first, :conditions => ["permalink = ?", params[:id].to_s])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end
end
