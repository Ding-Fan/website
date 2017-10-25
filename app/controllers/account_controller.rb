# Devise User Controller
class AccountController < Devise::RegistrationsController
  def new
    super
  end

  def edit
    redirect_to setting_path
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    resource.username = params[resource_name][:username]
    resource.email = params[resource_name][:email]
    # Use reCAPTCHA or rucaptcha
    if Figaro.env.RECAPTCHA_PRIVATE_KEY?
      if verify_recaptcha(resource) && resource.save
        sign_in(resource_name, resource)
      end
    else
      if verify_rucaptcha?(resource) && resource.save
        sign_in(resource_name, resource)
      end
    end
  end

  private

  # Overwrite the default url to be used after updating a resource.
  # It should be edit_user_registration_path
  # Note: resource param can't miss, because it's the super caller way.
  def after_update_path_for(_)
    edit_user_registration_path
  end
end
