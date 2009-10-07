class FeedsController < ApplicationController
  # GET /feeds
  # GET /feeds.xml
  def index
    @feeds = Feed.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @feeds }
    end
  end

  # GET /feeds/1
  # GET /feeds/1.xml
  def show
    @feed = Feed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feed }
    end
  end

  # GET /feeds/new
  # GET /feeds/new.xml
  def new
    @feed = Feed.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feed }
    end
  end

  # GET /feeds/1/edit
  def edit
    @feed = Feed.find(params[:id])
  end

  # POST /feeds
  # POST /feeds.xml
  def create
    @language = Language.find_by_code(params[:feed][:language_code])
    params[:feed].delete(:language_code)
    params[:feed][:language_id] =  @language.id

    @feed              = Feed.new(params[:feed])
    @feed.id           = params[:feed][:id]

    respond_to do |format|
      if @feed.save
        flash[:notice] = 'Feed was successfully created.'
        format.html { redirect_to(@feed) }
        format.xml  { render :xml => @feed, :status => :created, :location => @feed }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /feeds/1
  # PUT /feeds/1.xml
  def update
    @feed = Feed.find(params[:id])

    if params[:feed][:language_code]
      @language = Language.find_by_code(params[:feed][:language_code])
      params[:feed].delete(:language_code)
      params[:feed][:language_id] =  @language.id
    end

    respond_to do |format|
      if @feed.update_attributes(params[:feed])
        flash[:notice] = 'Feed was successfully updated.'
        format.html { redirect_to(@feed) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.xml
  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy

    respond_to do |format|
      format.html { redirect_to(feeds_url) }
      format.xml  { head :ok }
    end
  end

  # POST /associate_category/1
  # POST /associate_category/1.xml
  def associate_category
    @feed     = Source.find(params[:id])
    @category = Category.find(params[:category][:id])
    
    respond_to do |format|
      if @feed.categories.include?(@category) or (@feed.categories << @category and @feed.save)
        format.xml  { head :ok}
      else
        format.xml  { render :xml => @feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /disassociate_category/1
  # POST /disassociate_category/1.xml
  def disassociate_category
     @feed     = Source.find(params[:id])
     @category = Category.find(params[:category][:id])
    
    respond_to do |format|
      if not @feed.categories.include?(@category) or (@feed.categories.delete(@category) and @feed.save)
        format.xml  { head :ok}
      else
        format.xml  { render :xml => @feed.errors, :status => :unprocessable_entity }
      end
    end
  end

end
