class ApplicationController < ActionController::Base
  
  def default_render
    if @component_name.present?
      @component_name = @component_name.camelize
      
      respond_to do |format|
        format.html { render text: nil, layout: true }
        format.json { render json: @component_data }
      end
    else
      super
    end
  end
end