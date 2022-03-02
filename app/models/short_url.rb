class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validate :validate_full_url
  validates_presence_of :full_url
  validates :full_url, format: URI::regexp(%w[http https])

  def short_code
    # Converting id to base 36 and update the tests results
    shorted_url = self.id.to_s(36)
    update_column(:shorted_url, shorted_url)
    shorted_url
  end

  def update_title!
    UpdateTitleJob.perform_now(self)
  end

  # Find a full_url given a shorted_code
  def self.find_by_short_code(short_code)
    ShortUrl.find_by_shorted_url(short_code)
  end

  private

  def validate_full_url
  end

end
