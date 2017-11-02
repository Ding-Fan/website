include Homeland::Wiki

crumb :root do
  link I18n.t("menu.home"), main_app.root_path
end

crumb :sign do
  link "sign", sign_path, resource
  parent :root
end

crumb :about do
  link "about", about_path
  parent :root
end

crumb :sign_in do
  link I18n.t("common.login"), main_app.new_user_session_path
  parent :root
end

crumb :sign_up do
  link I18n.t("common.register"),main_app.new_user_registration_path
  parent :root
end

crumb :topics do
  link I18n.t("topics.topic_list.hot_topic"), topics_path
  parent :root
end

crumb :topic_new do |topic|
  link I18n.t("topics.new_topic"), new_topic_path
  parent :topics
end

crumb :topic_show do |topic|
  link I18n.t("topics.read_topic") + ": #{topic.name}", topic_path(topic)
  parent :topics
end

crumb :topic_edit do |topic|
  link I18n.t("topics.edit_topic") + ": #{topic.name}", edit_topic_path(topic)
  parent :topics
end

crumb :replies do
  link I18n.t("common.reply") + I18n.t("common.reply"), topic_path
end

crumb :wiki do
  link I18n.t("wiki.wiki_index"), wiki_path
  parent :root
end

crumb :wiki_new do |wiki|
  link I18n.t("wiki.new_page"), new_wiki_path
  parent :wiki
end

crumb :wiki_show do |wiki|
  link I18n.t("wiki.read") + ": #{wiki.title}", wiki_path(wiki)
  parent :wiki
end

crumb :wiki_edit do |wiki|
  link I18n.t("wiki.edit_page"), edit_wiki_path(wiki)
  parent :wiki
end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).