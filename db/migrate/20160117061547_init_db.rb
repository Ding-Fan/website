class InitDb < ActiveRecord::Migration[5.1]
  def change
    create_table 'authorizations', force: :cascade do |t|
      t.string   'provider', null: false
      t.string   'uid', limit: 1000, null: false
      t.integer  'user_id', null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index 'authorizations', %w(provider uid), using: :btree

    create_table 'comments', force: :cascade do |t|
      t.text     'body',                 null: false
      t.text     'body_html'
      t.integer  'user_id',              null: false
      t.string   'commentable_type'
      t.integer  'commentable_id'
      t.integer  'type',     default: 0, null: false
      t.integer  'status',   default: 0, null: false
      t.datetime 'deleted_at'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index 'comments', ['commentable_id'], using: :btree
    add_index 'comments', ['commentable_type'], using: :btree
    add_index 'comments', ['user_id'], using: :btree
    add_index 'comments', ['type'], using: :btree
    add_index 'comments', ['status'], using: :btree

    create_table 'exception_logs', force: :cascade do |t|
      t.string   'title',      null: false
      t.text     'body',       null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    create_table 'files', force: :cascade do |t|
      t.integer  'user_id'
      t.string   'name',        default: "", null: false
      t.string   'path',                     null: false
      t.integer  'size',        default: 0,  null: false
      t.integer  'type',        default: 0,  null: false
      t.integer  'status',      default: 0,  null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index 'files', ['user_id'], using: :btree
    add_index 'files', ['type'], using: :btree
    add_index 'files', ['status'], using: :btree

    create_table 'nodes', force: :cascade do |t|
      t.string   'name',                     null: false
      t.string   'slug',                     null: false
      t.string   'summary'
      t.integer  'section_id',               null: false
      t.integer  'sort',         default: 0, null: false
      t.integer  'topics_count', default: 0, null: false
      t.integer  'type',         default: 0, null: false
      t.integer  'status',       default: 0, null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index 'nodes', ['section_id'], using: :btree
    add_index 'nodes', ['type'], using: :btree
    add_index 'nodes', ['status'], using: :btree

    create_table 'notes', force: :cascade do |t|
      t.string   'title',                         null: false
      t.text     'body',                          null: false
      t.integer  'user_id',                       null: false
      t.integer  'type',          default: 0,     null: false
      t.integer  'status',        default: 0,     null: false
      t.integer  'word_count',    default: 0,     null: false
      t.integer  'changes_count', default: 0,     null: false
      t.boolean  'publish',       default: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index 'notes', ['user_id'], using: :btree
    add_index 'notes', ['type'], using: :btree
    add_index 'notes', ['status'], using: :btree

    create_table 'notifications', force: :cascade do |t|
      t.integer  'user_id',                  null: false
      t.boolean  'read',         default: false
      t.integer  'type',         default: 0, null: false
      t.integer  'status',       default: 0, null: false
      t.integer  'follower_id'
      t.integer  'node_id'
      t.integer  'topic_id'
      t.integer  'reply_id'
      t.integer  'mentionable_id'
      t.string   'mentionable_type'
      t.integer  'mentioned_user_ids', default: [], array: true
      t.integer  'changes_count',      default: 0, null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index 'notifications', ['read'], using: :btree
    add_index 'notifications', %w(user_id read), using: :btree
    add_index 'notifications', ['type'], using: :btree
    add_index 'notifications', ['status'], using: :btree

    create_table 'oauth_access_grants', force: :cascade do |t|
      t.integer  'resource_owner_id', null: false
      t.integer  'application_id',    null: false
      t.string   'token',             null: false
      t.integer  'expires_in',        null: false
      t.text     'redirect_uri',      null: false
      t.datetime 'created_at',        null: false
      t.datetime 'revoked_at'
      t.string   'scopes'
    end

    add_index 'oauth_access_grants', ['token'], unique: true, using: :btree

    create_table 'oauth_access_tokens', force: :cascade do |t|
      t.integer  'resource_owner_id'
      t.integer  'application_id'
      t.string   'token', null: false
      t.string   'refresh_token'
      t.integer  'expires_in'
      t.datetime 'revoked_at'
      t.datetime 'created_at', null: false
      t.string   'scopes'
    end

    add_index 'oauth_access_tokens', ['refresh_token'], unique: true, using: :btree
    add_index 'oauth_access_tokens', ['resource_owner_id'], using: :btree
    add_index 'oauth_access_tokens', ['token'], unique: true, using: :btree

    create_table 'oauth_applications', force: :cascade do |t|
      t.string   'name',                      null: false
      t.string   'uid',                       null: false
      t.string   'secret',                    null: false
      t.text     'redirect_uri',              null: false
      t.string   'scopes',       default: '', null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer  'owner_id'
      t.string   'owner_type'
    end

    add_index 'oauth_applications', %w(owner_id owner_type), using: :btree
    add_index 'oauth_applications', ['uid'], unique: true, using: :btree

    create_table 'page_versions', force: :cascade do |t|
      t.integer  'user_id',                null: false
      t.integer  'page_id',                null: false
      t.integer  'version',    default: 0, null: false
      t.string   'slug',                   null: false
      t.string   'title',                  null: false
      t.string   'desc',                   null: false
      t.text     'body',                   null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index 'page_versions', %w(page_id version), using: :btree
    add_index 'page_versions', ['page_id'], using: :btree

    create_table 'replies', force: :cascade do |t|
      t.integer  'user_id',                         null: false
      t.integer  'topic_id',                        null: false
      t.integer  'type',               default: 0,  null: false
      t.integer  'status',             default: 0,  null: false
      t.text     'body',                            null: false
      t.text     'body_html'
      t.integer  'state',              default: 1,  null: false
      t.integer  'liked_user_ids',     default: [],              array: true
      t.integer  'likes_count',        default: 0
      t.integer  'mentioned_user_ids', default: [],              array: true
      t.datetime 'deleted_at'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index 'replies', ['topic_id'], using: :btree
    add_index 'replies', ['user_id'], using: :btree
    add_index 'replies', ['type'], using: :btree
    add_index 'replies', ['status'], using: :btree

    create_table 'sections', force: :cascade do |t|
      t.string   'name',                   null: false
      t.integer  'sort',       default: 0, null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index 'sections', ['sort'], using: :btree

    create_table 'site_configs', force: :cascade do |t|
      t.string   'key',        null: false
      t.text     'value',      null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index 'site_configs', ['key'], using: :btree

    create_table 'site_nodes', force: :cascade do |t|
      t.string   'name',                      null: false
      t.integer  'sort',       default: 0,    null: false
      t.string   'locale',     default: 'en', null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index 'site_nodes', ['sort'], using: :btree

    create_table 'sites', force: :cascade do |t|
      t.integer  'user_id'
      t.integer  'site_node_id'
      t.integer  'type',    default: 0, null: false
      t.integer  'status',  default: 0, null: false
      t.string   'name',                null: false
      t.string   'url',                 null: false
      t.string   'desc'
      t.datetime 'deleted_at'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index 'sites', ['site_node_id'], using: :btree
    add_index 'sites', ['url'], using: :btree

    create_table 'topics', force: :cascade do |t|
      t.integer  'user_id',                            null: false
      t.integer  'node_id',                            null: false
      t.integer  'type',                   default: 0, null: false
      t.integer  'status',                 default: 0, null: false
      t.string   'title',                              null: false
      t.text     'body',                               null: false
      t.text     'body_html'
      t.integer  'last_reply_id'
      t.integer  'last_reply_user_id'
      t.string   'last_reply_user_username'
      t.string   'node_name'
      t.string   'who_deleted'
      t.integer  'last_active_mark'
      t.boolean  'lock_node', default: false
      t.datetime 'suggested_at'
      t.integer  'excellent', default: 0
      t.datetime 'replied_at'
      t.integer  'replies_count',      default: 0, null: false
      t.integer  'likes_count',        default: 0
      t.integer  'follower_ids',       default: [],                 array: true
      t.integer  'liked_user_ids',     default: [],                 array: true
      t.integer  'mentioned_user_ids', default: [],                 array: true
      t.datetime 'deleted_at'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index 'topics', ['excellent'], using: :btree
    add_index 'topics', ['last_active_mark'], using: :btree
    add_index 'topics', ['likes_count'], using: :btree
    add_index 'topics', ['node_id'], using: :btree
    add_index 'topics', ['suggested_at'], using: :btree
    add_index 'topics', ['user_id'], using: :btree
    add_index 'topics', ['type'], using: :btree
    add_index 'topics', ['status'], using: :btree

    create_table 'users', force: :cascade do |t|
      t.string   'username',                               null: false
      t.string   'password',               default: '',    null: false
      t.string   'email',                                  null: false
      t.boolean  'email_public',           default: false, null: false
      t.string   'phone'
      t.integer  'type',                   default: 0,     null: false
      t.integer  'status',                 default: 0,     null: false
      t.string   'locale',                 default: 'en',  null: false
      t.integer  'points',                 default: 0,     null: false
      t.string   'avatar'
      t.string   'bio'
      t.string   'website'
      t.string   'github'
      t.string   'google'
      t.string   'facebook'
      t.string   'twitter'
      t.string   'tagline'
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.string   'reset_password_token'
      t.datetime 'reset_password_sent_at'
      t.datetime 'remember_created_at'
      t.integer  'sign_in_count', default: 0, null: false
      t.datetime 'current_sign_in_at'
      t.datetime 'last_sign_in_at'
      t.string   'sign_up_ip'
      t.string   'current_sign_in_ip'
      t.string   'last_sign_in_ip'
      t.string   'password_salt',          default: '',    null: false
      t.string   'persistence_token',      default: '',    null: false
      t.string   'single_access_token',    default: '',    null: false
      t.string   'perishable_token',       default: '',    null: false
      t.integer  'topics_count',           default: 0,     null: false
      t.integer  'replies_count',          default: 0,     null: false
      t.string   'private_token'
      t.integer  'favorite_topic_ids',     default: [],                 array: true
      t.integer  'blocked_node_ids',       default: [],                 array: true
      t.integer  'blocked_user_ids',       default: [],                 array: true
      t.integer  'following_ids',          default: [],                 array: true
      t.integer  'follower_ids',           default: [],                 array: true
    end

    add_index 'users', ['username'], using: :btree
    add_index 'users', ['email'], using: :btree
    add_index 'users', ['private_token'], using: :btree
    add_index 'users', ['type'], using: :btree
    add_index 'users', ['status'], using: :btree

    create_table :wiki do |t|
      t.string  'title',                          null: false
      t.string  'slug',                           null: false
      t.string  'desc'
      t.text    'body',                           null: false
      t.string  'locale',         default: 'en',  null: false
      t.integer 'type',           default: 0,     null: false
      t.integer 'status',         default: 0,     null: false
      t.boolean 'locked',         default: false
      t.integer 'version',        default: 0,     null: false
      t.integer 'editor_ids',     default: [],    null: false, array: true
      t.integer 'word_count',     default: 0,     null: false
      t.integer 'changes_cout',   default: 1,     null: false
      t.integer 'comments_count', default: 0,     null: false
      t.datetime 'deleted_at'

      t.timestamps
    end

    add_index 'wiki', ['slug'], unique: true, using: :btree
    add_index 'wiki', ['type'], using: :btree
    add_index 'wiki', ['status'], using: :btree
  end
end
