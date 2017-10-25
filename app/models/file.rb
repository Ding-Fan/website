class Files < ApplicationRecord
  belongs_to :user

  self.inheritance_column = :_type_disabled 
  validates_presence_of :name

  # 封面图
  mount_uploader :name, FileUploader
end
