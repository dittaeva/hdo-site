class Representative < ActiveRecord::Base
  extend FriendlyId

  belongs_to :party
  belongs_to :district

  has_many :vote_results
  has_many :votes, :through => :vote_results
  has_many :propositions
  has_and_belongs_to_many :committees, :order => :name

  validates_uniqueness_of :first_name, :scope => :last_name # TODO: :scope => :period ?!

  friendly_id :external_id, :use => :slugged

  image_accessor :image
  before_save :ensure_image

  def display_name
    "#{last_name}, #{first_name}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def alternate_text
    alternate? ? I18n.t("app.yes") : I18n.t("app.no")
  end

  def age
    dob = date_of_birth or return -1

    if date_of_death
      now = date_of_death
    else
      now = Time.now
    end

    now = now.utc.to_date

    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def stats
    Hdo::Stats::RepresentativeCounts.new self
  end

  private

  def ensure_image
    return if known_image?

    root = Pathname.new(Rails.root)

    slug_image = root.join("app/assets/images/representatives/#{slug}.jpg")
    fallback   = root.join("app/assets/images/representatives/unknown.jpg")

    self.image = slug_image.exist? ? slug_image : fallback
  end

  def known_image?
    image and not image_name.start_with?('unknown')
  end
end
