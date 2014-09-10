# See http://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "johnm04"
client_key               "#{current_dir}/johnm04.pem"
validation_client_name   "johnm-validator"
validation_key           "#{current_dir}/johnm-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/johnm"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]

knife[:aws_access_key_id] = ENV['AWS_ACCESS_KEY']
knife[:aws_secret_access_key] = ENV['AWS_SECRET_KEY']
knife[:aws_ssh_key_id] = 'johnmAmazon'
knife[:region] = 'eu-west-1';
knife[:availability_zone] = 'eu-west-1a';
knife[:flavor] = "t2.micro"
