class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  # Display top 100 clicked shorted urls.
  def index
    @short_url = ShortUrl.all.order(click_count: :desc).limit(100)

    respond_to do |format|
      if @short_url
        format.json { render json: @short_url }
      else
        format.json { render json: @short_url.errors }
      end
    end
  end

  # Create that will generate the shorted_url and update the title.
  def create
    @short_url = ShortUrl.new(short_url_params)

    respond_to do |format|
      if @short_url.save
        @short_url.short_code
        @short_url.update_title!
        format.json { render json: @short_url }
      else
        format.json { render json: { "errors" => "Full url is not a valid url" }, status: :unprocessable_entity }
      end
    end
  end

  # Redirect to the web page, when a shorted url is clicked.
  def show
    @short_url = ShortUrl.find_by_short_code(params[:id])
    
    respond_to do |format|
      if @short_url.present?
        @short_url.increment!(:click_count)
        format.html { redirect_to @short_url.full_url }
        format.json { redirect_to @short_url.full_url }
      else
        format.json {render json: { "errors": "not_found" }, status: :not_found }
      end
    end

  end

  private

  def short_url_params
    params.permit(:full_url)
  end
end
