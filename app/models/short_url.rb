class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validate :validate_full_url
  validates_presence_of :full_url
  validates :full_url, format: URI::regexp(%w[http https])

  # Generate shorted_url
  def short_code
    # Converting id to base 62 as suggested by Randy and update the tests results
    short = ''
    id = self.id
    while id > 0
      short << CHARACTERS[id % 62]
      id /= 62
    end

    shorted_url = short.reverse
    update_column(:shorted_url, shorted_url)
    shorted_url
  end

  # Update DB with given Url page title.
  def update_title!
    UpdateTitleJob.perform_now(self)
  end

  # Find a full_url given a shorted_code
  def self.find_by_short_code(short_code)
    ShortUrl.find_by_shorted_url(short_code)
  end

  private

  def validate_full_url
    # Not used since the full_url will be validated with the regexp above.
  end

end
