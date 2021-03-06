# An end user.
#
# *Parameters:*
# * +username+ [String]  user public identification
# * +email+ [String]     user's email address
# * others               See https://github.com/plataformatec/devise
#
# *Associations:*
# * +has_many+ [Comment]          comments posted by the user
# * +has_many+ [DownVote]         negative votes posted by the user
# * +has_many+ [ProblemThread]    problem threads opened by the consumer
# * +has_many+ [UpVote]           positive votes posted by the user
class Consumer < ApplicationRecord
  include UserState

  devise :database_authenticatable,
         :confirmable,
         :lockable,
         :recoverable,
         :registerable,
         :rememberable,
         :trackable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :advice_threads, inverse_of: :author, dependent: :destroy
  has_many :comments, as: :author, dependent: :destroy
  has_many :down_votes, as: :downer, dependent: :destroy
  has_many :problem_threads, inverse_of: :author, dependent: :destroy
  has_many :relationships, dependent: :destroy
  has_many :up_votes, as: :upper, dependent: :destroy

  has_many :following_advices, through: :relationships, source: :followed, source_type: AdviceThread.name
  has_many :following_problems, through: :relationships, source: :followed, source_type: ProblemThread.name

  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }, allow_blank: true,
                    consumer_authentication: true, user_uniqueness: true

  validates :password, confirmation: true, length: { in: 8..128 }, on: :create
  validates :password, confirmation: true, length: { in: 8..128 }, allow_blank: true, on: :update

  validates :username, format: { with: /\A\w{5,32}\z/ }, reserved_name: true, uniqueness: { case_sensitive: false },
                       on: :create

  # Creates a new Consumer from an OmniAuth response and info inserted by the user.
  def self.from_omniauth(auth, params)
    consumer = Consumer.new

    consumer.assign_attributes params
    consumer.assign_attributes email: auth['info']['email'], provider: auth['provider'], uid: auth['uid']

    # Skips confirmation if the email is provided by Facebook or there is no email
    consumer.skip_confirmation! if
      (consumer.email = auth['info']['email'].presence) ||
      !(consumer.email = params[:email].presence)

    consumer
  end

  # Connects a Consumer with Facebook
  def facebook_connect(auth)
    self.provider = auth[:provider]
    self.uid = auth[:uid]
    save
  end

  # Disconnects a Consumer from Facebook
  def facebook_disconnect
    self.provider = nil
    self.uid = nil
    save
  end

  def soft_delete
    self.provider = nil
    self.uid = nil
    super
  end

  def to_param
    username
  end

  def follow(resource)
    Relationship.create(consumer: self, followed: resource)
  end

  def follow?(resource)
    !(resource.is_a?(AdviceThread) ? following_advices : following_problems).where(id: resource.id).empty?
  end

  def unfollow(resource)
    relationships.find_by(followed: resource).destroy
  end
end
