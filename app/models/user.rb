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

  has_many :exercises, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :teams_created, class_name: :Team, foreign_key: :owner_id, dependent: :destroy
  has_and_belongs_to_many :teams
  has_many :comments, dependent: :destroy
  has_many :messages_received, class_name: :Message, foreign_key: :receiver_id
  has_many :messages_sended, class_name: :Message, foreign_key: :sender_id

  # Check if the user is the owner of a specific team.
  def owner?(team)
    teams_created.include?(team)
  end

  def teams_from_where_belongs
    teams + teams_created
  end

  # Get similarity between two users, if already calculated.
  def similarity_with(user)
    query_result = UserConnectionQuery.new.similarity(
      user_1: self,
      user_2: user
    ).first
    if query_result then query_result.similarity else nil end
  end

  private

  # Generate random anonymous id.
  def generate_anonymous_id
    self.anonymous_id = SecureRandom.hex(4)
  end
end
