# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171017041401) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.string "action_type", null: false
    t.string "action_option"
    t.string "target_type"
    t.integer "target_id"
    t.string "user_type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["target_type", "target_id", "action_type"], name: "index_actions_on_target_type_and_target_id_and_action_type"
    t.index ["user_type", "user_id", "action_type"], name: "index_actions_on_user_type_and_user_id_and_action_type"
  end

  create_table "authorizations", force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", limit: 1000, null: false
    t.integer "user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["provider", "uid"], name: "index_authorizations_on_provider_and_uid"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body", null: false
    t.integer "user_id", null: false
    t.string "commentable_type"
    t.integer "commentable_id"
    t.integer "type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["commentable_id"], name: "index_comments_on_commentable_id"
    t.index ["commentable_type"], name: "index_comments_on_commentable_type"
    t.index ["status"], name: "index_comments_on_status"
    t.index ["type"], name: "index_comments_on_type"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "devices", force: :cascade do |t|
    t.integer "platform", null: false
    t.integer "user_id", null: false
    t.string "token", null: false
    t.datetime "last_actived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "exception_tracks", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "files", force: :cascade do |t|
    t.integer "user_id"
    t.string "name", default: "", null: false
    t.string "path", null: false
    t.integer "size", default: 0, null: false
    t.integer "type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["status"], name: "index_files_on_status"
    t.index ["type"], name: "index_files_on_type"
    t.index ["user_id"], name: "index_files_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.integer "users_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_locations_on_name"
  end

  create_table "new_notifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "actor_id"
    t.string "notify_type", null: false
    t.string "target_type"
    t.integer "target_id"
    t.string "second_target_type"
    t.integer "second_target_id"
    t.string "third_target_type"
    t.integer "third_target_id"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_new_notifications_on_user_id"
  end

  create_table "nodes", force: :cascade do |t|
    t.string "name", null: false
    t.string "summary"
    t.integer "section_id", null: false
    t.integer "sort", default: 0, null: false
    t.integer "topics_count", default: 0, null: false
    t.integer "type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["section_id"], name: "index_nodes_on_section_id"
    t.index ["sort"], name: "index_nodes_on_sort"
    t.index ["status"], name: "index_nodes_on_status"
    t.index ["type"], name: "index_nodes_on_type"
  end

  create_table "notes", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.integer "user_id", null: false
    t.integer "type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.integer "word_count", default: 0, null: false
    t.integer "changes_count", default: 0, null: false
    t.boolean "publish", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["status"], name: "index_notes_on_status"
    t.index ["type"], name: "index_notes_on_type"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.bigint "expires_in"
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.bigint "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "owner_id"
    t.string "owner_type"
    t.integer "level", default: 0, null: false
    t.index ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "page_versions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "page_id", null: false
    t.integer "version", default: 0, null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.string "desc", null: false
    t.text "body", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["page_id"], name: "index_page_versions_on_page_id"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.boolean "locked", default: false
    t.integer "version", default: 0, null: false
    t.integer "editor_ids", default: [], null: false, array: true
    t.integer "word_count", default: 0, null: false
    t.integer "changes_cout", default: 1, null: false
    t.integer "comments_count", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_pages_on_slug", unique: true
  end

  create_table "replies", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "topic_id", null: false
    t.integer "type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.text "body", null: false
    t.integer "state", default: 1, null: false
    t.integer "likes_count", default: 0
    t.integer "mentioned_user_ids", default: [], array: true
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "action"
    t.string "target_type"
    t.string "target_id"
    t.integer "reply_to_id"
    t.index ["deleted_at"], name: "index_replies_on_deleted_at"
    t.index ["status"], name: "index_replies_on_status"
    t.index ["topic_id"], name: "index_replies_on_topic_id"
    t.index ["type"], name: "index_replies_on_type"
    t.index ["user_id"], name: "index_replies_on_user_id"
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string "name", null: false
    t.string "environment"
    t.text "certificate"
    t.string "password"
    t.integer "connections", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "auth_key"
    t.string "client_id"
    t.string "client_secret"
    t.string "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string "device_token", limit: 64, null: false
    t.datetime "failed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "app_id"
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token"
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer "badge"
    t.string "device_token", limit: 64
    t.string "sound"
    t.text "alert"
    t.text "data"
    t.integer "expiry", default: 86400
    t.boolean "delivered", default: false, null: false
    t.datetime "delivered_at"
    t.boolean "failed", default: false, null: false
    t.datetime "failed_at"
    t.integer "error_code"
    t.text "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "alert_is_json", default: false
    t.string "type", null: false
    t.string "collapse_key"
    t.boolean "delay_while_idle", default: false, null: false
    t.text "registration_ids"
    t.integer "app_id", null: false
    t.integer "retries", default: 0
    t.string "uri"
    t.datetime "fail_after"
    t.boolean "processing", default: false, null: false
    t.integer "priority"
    t.text "url_args"
    t.string "category"
    t.boolean "content_available", default: false
    t.text "notification"
    t.boolean "mutable_content", default: false
    t.index ["delivered", "failed"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))"
  end

  create_table "sections", force: :cascade do |t|
    t.string "name", null: false
    t.integer "sort", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["sort"], name: "index_sections_on_sort"
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "site_nodes", force: :cascade do |t|
    t.string "name", null: false
    t.integer "sort", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["sort"], name: "index_site_nodes_on_sort"
  end

  create_table "sites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "site_node_id"
    t.integer "type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "name", null: false
    t.string "url", null: false
    t.string "desc"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["deleted_at"], name: "index_sites_on_deleted_at"
    t.index ["site_node_id"], name: "index_sites_on_site_node_id"
    t.index ["url"], name: "index_sites_on_url"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "topics", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "node_id", null: false
    t.integer "type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.text "body", null: false
    t.integer "last_reply_id"
    t.integer "last_reply_user_id"
    t.string "last_reply_user_username"
    t.string "node_name"
    t.string "who_deleted"
    t.integer "last_active_mark"
    t.boolean "lock_node", default: false
    t.datetime "suggested_at"
    t.integer "excellent", default: 0
    t.datetime "replied_at"
    t.integer "replies_count", default: 0, null: false
    t.integer "likes_count", default: 0
    t.integer "mentioned_user_ids", default: [], array: true
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "closed_at"
    t.index ["deleted_at"], name: "index_topics_on_deleted_at"
    t.index ["excellent"], name: "index_topics_on_excellent"
    t.index ["last_active_mark"], name: "index_topics_on_last_active_mark"
    t.index ["likes_count"], name: "index_topics_on_likes_count"
    t.index ["node_id", "deleted_at"], name: "index_topics_on_node_id_and_deleted_at"
    t.index ["status"], name: "index_topics_on_status"
    t.index ["suggested_at"], name: "index_topics_on_suggested_at"
    t.index ["type"], name: "index_topics_on_type"
    t.index ["user_id"], name: "index_topics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 100, null: false
    t.string "email", null: false
    t.string "email_md5", null: false
    t.boolean "email_public", default: false, null: false
    t.integer "type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "location"
    t.integer "location_id"
    t.string "bio"
    t.string "website"
    t.string "company"
    t.string "github"
    t.string "google"
    t.string "facebook"
    t.string "twitter"
    t.string "avatar"
    t.boolean "verified", default: false, null: false
    t.integer "state", default: 1, null: false
    t.string "tagline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "sign_up_ip"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "password_salt", default: "", null: false
    t.string "persistence_token", default: "", null: false
    t.string "single_access_token", default: "", null: false
    t.string "perishable_token", default: "", null: false
    t.integer "topics_count", default: 0, null: false
    t.integer "replies_count", default: 0, null: false
    t.integer "follower_ids", default: [], array: true
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.integer "followers_count", default: 0
    t.integer "following_count", default: 0
    t.index "lower((username)::text) varchar_pattern_ops", name: "index_users_on_lower_username_varchar_pattern_ops"
    t.index ["email"], name: "index_users_on_email"
    t.index ["location"], name: "index_users_on_location"
    t.index ["status"], name: "index_users_on_status"
    t.index ["type"], name: "index_users_on_type"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username"
  end

  create_table "wiki", force: :cascade do |t|
    t.string "slug", null: false
    t.string "title", null: false
    t.string "desc"
    t.text "body", null: false
    t.integer "type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.boolean "locked", default: false
    t.integer "version", default: 0, null: false
    t.integer "editor_ids", default: [], null: false, array: true
    t.integer "word_count", default: 0, null: false
    t.integer "changes_cout", default: 1, null: false
    t.integer "comments_count", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_wiki_on_slug", unique: true
    t.index ["status"], name: "index_wiki_on_status"
    t.index ["type"], name: "index_wiki_on_type"
  end

end
