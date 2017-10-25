class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include Searchable
  include OmniauthCallbacks
  include Blockable
  include Likeable
  include Followable
  include TopicRead
  include TopicFavorite
  include GithubRepository
  include UserCallbacks
  include ProfileFields

  acts_as_token_authenticatable
  self.inheritance_column = :_type_disabled 

  second_level_cache expires_in: 2.weeks

  devise :invitable, :database_authenticatable, :registerable, :recoverable, :lockable,
         :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:github, :google_oauth2, :facebook, :twitter]

  mount_uploader :avatar, AvatarUploader
  self.inheritance_column = :_type_disabled 

  has_many :topics, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :files
  has_many :oauth_applications, class_name: "Doorkeeper::Application", as: :owner
  has_many :devices

  attr_accessor :password_confirmation

  ACCESSABLE_ATTRS = [:username, :email_public, :locale, :points, :bio, :website, :github, :google, :facebook, :twitter,
                      :tagline, :avatar, :by, :current_password, :password, :password_confirmation,
                      :_rucaptcha]

  enum status: { deleted: -2, banned: -1, noverified: 0, normal: 1 }

  validates :username,
            length: { in: 3..20 },
            presence: true,
            uniqueness: { case_sensitive: false }
  validates :email, 'valid_email_2/email': { mx: true, disposable: true }

  scope :hot, -> { order(replies_count: :desc).order(topics_count: :desc) }
  scope :fields_for_list, lambda {
    select(:id, :username, :email, :email_public, :phone, :type, :status, :locale, :points,
           :tagline, :github, :google, :facebook, :twitter, :website, 
           :created_at, :updated_at)
  }

  def self.find_by_email(email)
    fetch_by_uniq_keys(email: email)
  end

  def self.find_by_username!(slug)
    find_by_username(slug) || raise(ActiveRecord::RecordNotFound.new(slug: slug))
  end

  def self.find_by_username(slug)
    fetch_by_uniq_keys(username: slug) || where("lower(username) = ?", slug.downcase).take
  end

  def self.find_by_username_or_email(username_or_email)
    username_or_email = username_or_email.downcase
    find_by_username(username_or_email) || find_by_email(username_or_email)
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    user = conditions.delete(:username)
    user.downcase!
    where(conditions.to_h).where(["(lower(username) = :value OR lower(email) = :value) and state != -1", { value: user }]).first
  end

  def self.current
    Thread.current[:current_user]
  end

  def self.current=(user)
    Thread.current[:current_user] = user
  end

  def self.search(term, options = {})
    limit = (options[:limit] || 30).to_i
    user = options[:user]
    following = []
    term = term.to_s + "%"
    users = User.where("username ilike ? or name ilike ?", term, term).order("replies_count desc").limit(limit).to_a
    if user
      following = user.follow_users.where("username ilike ? or name ilike ?", term, term).to_a
    end
    users.unshift(*Array(following))
    users.uniq!
    users.compact!

    users.first(limit)
  end

  def to_param
    username
  end

  def user_type
    (self[:type] || "User").underscore.to_sym
  end

  def email=(val)
    self[:email] = val
  end

  def password_required?
    (authorizations.empty? || !password.blank?) && super
  end

  def profile_url
    "/#{username}"
  end

  def github_url
    return "" if github.blank?
    "https://github.com/#{github.split('/').last}"
  end

  def google_url
    return "" if google.blank?
    "https://google.com/#{google.split('/').last}"
  end

  def facebook_url
    return "" if facebook.blank?
    "https://facebook.com/#{facebook}"
  end

  def twitter_url
    return "" if twitter.blank?
    "https://twitter.com/#{twitter}"
  end

  def website_url
    return "" if website.blank?
    website[%r{^https?://}] ? website : "http://#{website}"
  end

  # 是否是管理员
  def admin?
    type >= 3
  end

  # 是否有 Wiki 维护权限
  def wiki_editor?
    self.admin? || topics_count >= 10
  end

  # 回帖大于 150 的才有酷站的发布权限
  def site_editor?
    self.admin? || replies_count >= 100
  end

  # 是否能发帖
  def newbie?
    return false if verified?
    t = Setting.newbie_limit_time.to_i
    return false if t == 0
    created_at > t.seconds.ago
  end

  def roles?(role)
    case role
    when :admin then admin?
    when :wiki_editor then wiki_editor?
    when :site_editor then site_editor?
    when :member then self.normal?
    else false
    end
  end

  # 用户的账号类型
  def level
    if admin?
      "admin"
    elsif verified?
      "verified"
    elsif banned?
      "banned"
    elsif newbie?
      "newbie"
    else
      "normal"
    end
  end

  def level_name
    I18n.t("common.#{level}_user")
  end

  # Override Devise to send mails with async
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def bind?(provider)
    authorizations.collect(&:provider).include?(provider)
  end

  def bind_service(response)
    provider = response["provider"]
    uid = response["uid"].to_s
    authorizations.create(provider: provider, uid: uid)
  end

  # 软删除
  def soft_delete
    self.state = "deleted"
    save(validate: false)
  end

  def letter_avatar_url(size)
    path = LetterAvatar.generate(self.login, size).sub("public/", "/")

    "#{Setting.base_url}#{path}"
  end

  def large_avatar_url
    if self[:avatar].present?
      self.avatar.url(:lg)
    else
      self.letter_avatar_url(192)
    end
  end

  def avatar?
    self[:avatar].present?
  end

  # @example.com 的可以修改邮件地址
  def email_locked?
    self.email.exclude?("@example.com")
  end

  def calendar_data
    Rails.cache.fetch(["user", self.id, "calendar_data", Date.today, "by-months"]) do
      calendar_data_without_cache
    end
  end

  def calendar_data_without_cache
    date_from = 12.months.ago.beginning_of_month.to_date
    replies = self.replies.where("created_at > ?", date_from)
                  .group("date(created_at AT TIME ZONE 'CST')")
                  .select("date(created_at AT TIME ZONE 'CST') AS date, count(id) AS total_amount").all

    replies.each_with_object({}) do |reply, timestamps|
      timestamps[reply["date"].to_time.to_i.to_s] = reply["total_amount"]
    end
  end

  # for Searchable
  def as_indexed_json(_options = {})
    as_json(only: [:username, :name, :tagline, :bio, :email, :location])
  end

  def indexed_changed?
    %i(login name tagline bio email location).each do |key|
      return true if saved_change_to_attribute?(key)
    end
    false
  end
end
