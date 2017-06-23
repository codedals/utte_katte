# Load the rails application
require File.expand_path('../application', __FILE__)
require 'socket'
require 's3'
require 'dejisute_s3'

# Initialize the rails application
UtteKatte::Application.initialize!

ADMIN_DOMAINS = ["dev","staging"]
SUBDOMAIN = Socket.gethostname
APP_DOMAIN = "http://localhost:3000"

PLACEHOLDER_CARD="4242424242424242"

#AWS::S3::Base.establish_connection!(
#                                    :access_key_id     => 'AKIAIMOCABVBKCJ6P7HQ', 
#                                    :secret_access_key => '8oFnVZaIY22oQnUmAYdE9kS6Am95miLBDs0lVLFQ'
#                                    )
#AWS::S3::DEFAULT_HOST.replace "s3-website-ap-northeast-1.amazonaws.com"

S3_CONN = S3::Service.new(:access_key_id => "AKIAIMOCABVBKCJ6P7HQ",
                          :secret_access_key => "8oFnVZaIY22oQnUmAYdE9kS6Am95miLBDs0lVLFQ")


AWS_URL = "https://s3-ap-northeast-1.amazonaws.com"
AWS_BUCKET = "dejisuteuploadsdev"
AWS_UPLOAD_DIR = "files"
