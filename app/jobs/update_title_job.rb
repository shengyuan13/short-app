class UpdateTitleJob < ApplicationJob
  queue_as :default

  def perform(short_url)
    # Using Mechanize gem to scrap the url content
    page_scrap = Mechanize.new.get(short_url.full_url)
    short_url.title = page_scrap.title
    short_url.save!
  end
end
