class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :customers, dependent: :destroy
  has_many :machines, through: :customers
  has_many :jobs, dependent: :destroy
  has_many :tasks, through: :jobs
  has_many :prospects, dependent: :destroy
  has_many :contractors, dependent: :destroy
  has_many :lease_agreements, dependent: :destroy
  has_many :quotes, dependent: :destroy
end