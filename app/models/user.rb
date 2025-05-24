class User < ApplicationRecord
    has_secure_password
    has_many :post, dependent: :destroy
    has_many :comment, dependent: :destroy

    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
