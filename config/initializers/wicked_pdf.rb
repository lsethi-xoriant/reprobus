#WickedPdf.config = {
  #:wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
  #:layout => "pdf.html",ge 
  #:exe_path => '/usr/local/bin/wkhtmltopdf-amd64'
  #:exe_path => Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s
  #exe_path: "#{ENV['GEM_HOME']}/gems/wkhtmltopdf-binary-edge-#{Gem.loaded_specs['wkhtmltopdf-binary-edge'].version}/bin/wkhtmltopdf"
  
#}

WickedPdf.config do |config|  
  if Rails.env == 'production' then
    config.exe_path = Rails.root.to_s + "/bin/wkhtmltopdf"
  end
end