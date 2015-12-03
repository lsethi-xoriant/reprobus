# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone

require 'action_controller'

Mime::Type.register "application/xls", :xls
Mime::Type.register 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', :docx
Mime::Type.register "text/richtext", :rtf

ActionController::Renderers.add :docx do |filename, options|
  # Converting works great except < and > are escaped in codes!
  # http://stackoverflow.com/questions/30916575/converting-markdown-to-docx-using-pandoc-and-signs-in-code-is-translated-to
  # https://github.com/alphabetum/pandoc-ruby/issues/14
  # document = PandocRuby.convert render_to_string(options), to: :docx
  document = PandocRuby.html(render_to_string(options)).to_docx
  send_data document, filename:    "#{filename}.docx",
                      type:        Mime::DOCX,
                      disposition: 'attachment'
end

module ActionController
  # For respond_with default
  class Responder
    def to_docx
      if @default_response
        @default_response.call(options)
      else
        controller.render({ docx: controller.action_name }.merge(options))
      end
    end
  end
end
