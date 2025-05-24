class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tag
  has_many :tag, through: :post_tag

  has_many :comments, dependent: :destroy
  validate :must_have_at_least_one_tag

  after_create :schedule_deletion

  private

  def must_have_at_least_one_tag
    errors.add(:tags, "Post must have at least one tag!") if tags.empty?
  end

  def schedule_deletion
    DeletePostJob.perform(self.id)
  end
end
end
