require 'carrierwave'
require 'carrierwave/validations/active_model'

class NullStorage
  attr_reader :uploader

  def initialize(uploader)
    @uploader = uploader
  end

  def identifier
    uploader.filename
  end

  def store!(_file)
    true
  end

  def retrieve!(_identifier)
    true
  end
end

CarrierWave.configure do |config|
  # http://stackoverflow.com/questions/7534341/rails-3-test-fixtures-with-carrierwave/25315883#25315883
  config.storage NullStorage if Rails.env.test?

  case Figaro.env.UPLOAD_PROVIDER
  when 'aws'
    config.storage = :aws
    config.aws_bucket = Figaro.env.AWS_BUCKET
    config.aws_acl    = 'public-read'
    config.asset_host = Figaro.env.AWS_ASSET_HOST
    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7
    config.aws_attributes = {
      expires: 1.week.from_now.httpdate,
      cache_control: 'max-age=604800'
    }
    config.aws_credentials = {
      access_key_id:     Figaro.env.AWS_ACCESS_KEY_ID,
      secret_access_key: Figaro.env.AWS_SECRET_ACCESS_KEY,
      region:            Figaro.env.AWS_REGION # Required
    }
  when 'azure'
    config.storage = :azure
    config.azure_storage_account_name = Figaro.env.AZURE_STORAGE_ACCOUNT_NAME
    config.azure_storage_access_key = Figaro.env.AZURE_STORAGE_ACCESS_KEY
    config.azure_storage_blob_host = Figaro.env.AZURE_STORAGE_BLOB_HOST # optional
    config.azure_container = Figaro.env.AZURE_CONTAINER_NAME
    config.asset_host = Figaro.env.AZURE_CDN_HOST # optional
  when 'aliyun'
    config.storage = :aliyun
    config.aliyun_access_id  = Figaro.env.ALIYUN_UPLOAD_ACCESS_ID
    config.aliyun_access_key = Figaro.env.ALIYUN_UPLOAD_ACCESS_KEY
    config.aliyun_bucket     = Figaro.env.ALIYUN_UPLOAD_BUCKET
    config.aliyun_internal   = Figaro.env.ALIYUN_UPLOAD_ALIYUN_INTERNAL.to_s == 'false' ? false : true
    config.aliyun_area       = Figaro.env.ALIYUN_UPLOAD_ALIYUN_AREA
    config.aliyun_host       = Figaro.env.ALIYUN_HOST
  when 'qiniu'
    config.storage = :qiniu
    config.qiniu_access_key     = Figaro.env.QINIU_ACCESS_KEY
    config.qiniu_secret_key     = Figaro.env.QINIU_SECRET_KEY
    config.qiniu_bucket         = Figaro.env.QINIU_BUCKET
    config.qiniu_bucket_domain  = Figaro.env.QINIU_BUCKET_DOMAIN
    config.qiniu_bucket_private = true #default is false
    config.qiniu_block_size     = 4*1024*1024
    config.qiniu_protocol       = Figaro.env.QINIU_PROTOCOL
    config.qiniu_up_host        = Figaro.env.QINIU_UP_HOST #七牛上传海外服务器,国内使用可以不要这行配置
  when 'upyun'
    config.storage = :upyun
    # Do not remove previously file after new file uploaded
    config.remove_previously_stored_files_after_update = false
    config.upyun_username = Figaro.env.UPYUN_ACCESS_KEY
    config.upyun_password = Figaro.env.UPYUN_SECRET_KEY
    config.upyun_bucket = Figaro.env.UPYUN_UPLOAD_BUCKET
    config.upyun_bucket_host = Figaro.env.UPYUN_BUCKET_HOST
  else
    config.storage = :file
  end
end
