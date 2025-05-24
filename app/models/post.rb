class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  has_many :comments, dependent: :destroy
  validate :must_have_at_least_one_tag

  after_create :schedule_deletion

  private

  def must_have_at_least_one_tag
    errors.add(:tags, "Post must have at least one tag!") if tags.empty?
  end

  def schedule_deletion
    DeletePostJob.perform_in(24.hours, self.id)
  end

end
