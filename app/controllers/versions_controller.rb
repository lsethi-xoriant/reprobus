class VersionsController < ApplicationController
  def revert
    @version = PaperTrail::Version.find(params[:id])
    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end
    
    
    if params[:redo] == "true"  
      link_name = "(Undo)" 
      boolStr = "false"
      action_name = "reinstated"
    else
      link_name = "(Redo)"
      boolStr = "true"
      action_name = "reversed"
    end 
    
    link = view_context.link_to(link_name, revert_version_path(@version.next, 
      :redo => boolStr), :method => :post)
    flash[:success] = "#{@version.event.capitalize} #{action_name}.  #{link}"
    redirect_to :back
  end
  

end
