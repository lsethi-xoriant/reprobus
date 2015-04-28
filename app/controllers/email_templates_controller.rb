class EmailTemplatesController < ApplicationController
  before_filter :signed_in_user
  
  def show
    @email_template = EmailTemplate.find(params[:id])
  end

  def edit
    @email_template = EmailTemplate.find(params[:id])
  end

  def index
    @email_templates = EmailTemplate.all.paginate(page: params[:page])
  end

  def new
    @email_template = EmailTemplate.new
  end
  
  def create
    @email_template = EmailTemplate.new(email_template_params)

    if @email_template.save
      flash[:success] = "#{@email_template.name} created!"
      redirect_to @email_template
    else
      render 'new'
    end
  end
  
  def update
     @email_template = EmailTemplate.find(params[:id])

    if @email_template.update_attributes(email_template_params)
      flash[:success] = "#{@email_template.name} updated"
      redirect_to @email_template
    else
      render 'edit'
    end
  end
  
private
    def email_template_params
      params.require(:email_template).permit(:name, :from_email, :from_name, :subject, :body,
        :copy_assigned_user)
    end
end

