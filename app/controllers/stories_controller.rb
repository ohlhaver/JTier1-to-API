class StoriesController < ApplicationController
  # GET /stories
  # GET /stories.xml
  #def index
  #  @stories = Story.all

  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.xml  { render :xml => @stories }
  #  end
  #end

  # GET /stories/1
  # GET /stories/1.xml
  def show
    @story = Story.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @story }
    end
  end

  # GET /stories/new
  # GET /stories/new.xml
  #def new
  #  @story = Story.new

  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.xml  { render :xml => @story }
  #  end
  #end

  ## GET /stories/1/edit
  #def edit
  #  @story = Story.find(params[:id])
  #end

  # POST /stories
  # POST /stories.xml

  def create
    return if params[:story][:id] && render_head_ok_if_exists?( Story, params[:story][:id], :field => :jcrawl_story_id )
    
    language             = Language.find_by_code( params[:story][:language_code] )
    params[:story].delete(:language_code)
    params[:story][:language_id] = language.id if language
    
    author_names = params[:story][:author_names].is_a?(Hash) ? params[:story][:author_names].values : Array( params[:story][:author_names] )
    authors = Author.create_or_find( author_names )
    params[:story].delete(:author_names)

    @story = Story.new(
      :title             => JCore::Clean.headline( params[:story][:title] || '' ),
      :url               => params[:story][:url],
      :language_id       => params[:story][:language_id],
      :feed_id           => params[:story][:feed_id],
      :source_id         => params[:story][:source_id],
      :is_opinion        => (params[:story][:is_opinion] == 'true'),
      :is_blog           => (params[:story][:is_blog] == 'true'),
      :is_video          => (params[:story][:is_video] == 'true'),
      :subscription_type => params[:story][:subscription_type],
      :thumbnail_exists => !params[:story][:image].blank?,
      :created_at        => params[:story][:created_at]
    )
    
    @story.jcrawl_story_id = params[:story][:id] # associate the id with the jcrawl_story_id field
    
    authors.each{|a| @story.authors << a}
    
    @story.story_content = StoryContent.new(:body => params[:story][:content])
    
    unless params[:story][:image].blank?
      thumbnail = Thumbnail.create( params[:story][:image].merge( 
        :source_id => params[:story][:source_id],
        :available_in_storage => false ) 
      )
      if thumbnail.new_record?
        thumbnail.errors.each do |atr,msg|
          @story.errors.add("thumbnail_#{atr}", msg)
        end
      else
        @story.thumbnail = thumbnail
      end
    end
    
    respond_to do |format|
      if @story.errors.blank? and @story.save
        #flash[:notice] = 'Story was successfully created.'
        #format.html { redirect_to(@story) }
        format.xml  { render :xml => @story, :status => :created, :location => @story }
      else
        #format.html { render :action => "new" }
        format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stories/1
  # PUT /stories/1.xml
  #def update
  #  @story = Story.find(params[:id])

  #  respond_to do |format|
  #    if @story.update_attributes(params[:story])
  #      flash[:notice] = 'Story was successfully updated.'
  #      format.html { redirect_to(@story) }
  #      format.xml  { head :ok }
  #    else
  #      format.html { render :action => "edit" }
  #      format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /stories/1
  # DELETE /stories/1.xml
  #def destroy
  #  @story = Story.find(params[:id])
  #  @story.destroy

  #  respond_to do |format|
  #    format.html { redirect_to(stories_url) }
  #    format.xml  { head :ok }
  #  end
  #end
end
