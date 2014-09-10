name "production"
description "For Production!"
cookbook "apache", "= 0.2.0"
cookbook "chef-client", "= 3.7.0"
cookbook "logrotate", "= 1.6.0"
cookbook "cron", "= 1.4.0"


default_attributes(
  "chef_client" => {
    "interval" => 300
  }
)
