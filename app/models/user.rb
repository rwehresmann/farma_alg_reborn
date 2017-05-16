class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  before_validation :generate_anonymous_id

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name, :anonymous_id
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates_inclusion_of :teacher, in: [true, false]
  validates_inclusion_of :admin, in: [true, false]

  has_many :exercises
  has_many :answers
  has_many :teams_created, class_name: 'Team', foreign_key: "owner_id"
  has_and_belongs_to_many :teams
  has_many :comments

  # Check if the user is the owner of a specific team.
  def owner?(team)
    teams_created.include?(team)
  end

  def teams_from_where_belongs
    teams + teams_created
  end

  private

  # Generate random anonymous id.
  def generate_anonymous_id
    self.anonymous_id = SecureRandom.hex(4)
  end
end
