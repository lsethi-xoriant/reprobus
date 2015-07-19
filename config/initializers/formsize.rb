# getting error MultipartPartLimitError: Too many open files
# setting this is supposed to fix it. appears to be a bug.. should be able to remove in later releases. 
# for reference, it was happening when creating itineraries with a few rows. 
Rack::Utils.multipart_part_limit = 0