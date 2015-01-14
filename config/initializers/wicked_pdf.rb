WickedPdf.config = {
  #:wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
  #:layout => "pdf.html",ge 
  #:exe_path => '/usr/local/bin/wkhtmltopdf-amd64'
  #:exe_path => Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s
  exe_path: "#{ENV['GEM_HOME']}/gems/wkhtmltopdf-binary-#{Gem.loaded_specs['wkhtmltopdf-binary'].version}/bin/wkhtmltopdf"
}
