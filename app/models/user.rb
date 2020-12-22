class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :students, dependent: :destroy

  validates :last_name, presence: true, length: { minimum: 3, maximum: 40 }
  validates :first_name, presence: true, length: { minimum: 3, maximum: 40 }
  validates :middle_name, presence: true, length: { minimum: 3, maximum: 60 }
  validates :email, length: { maximum: 100 }, uniqueness: true, format: /\A[^@\s]+@(?:[-a-z0-9]+\.)+[a-z]{2,}\z/i

  def full_name
    "#{last_name.capitalize} #{first_name.capitalize} #{middle_name.capitalize}"
  end
end
