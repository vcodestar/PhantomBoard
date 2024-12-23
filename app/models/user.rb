class User < ApplicationRecord

  before_validation :set_fake_email
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :email, presence: false
  validates :email, uniqueness: false

  FLAG_THRESHOLD = 5
  # Devise modules for authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Association to posts
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Association to likes
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  # You can add validations for username or other fields here
  validates :username, presence: true, uniqueness: true

  def admin?
    self.admin
  end

  def flagged_for_review?
    flags >= FLAG_THRESHOLD
  end

  private

  def set_fake_email
    self.email = "#{username}@mail.fake" if email.blank? && username.present?
  end

end
