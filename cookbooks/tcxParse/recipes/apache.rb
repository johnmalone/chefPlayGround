#
# Cookbook Name:: tcxParse
# Recipe:: default
#
# Copyright 2014, TCX Parse
#
# All rights reserved - Do Not Redistribute
#

package "apache2" do
  action :install
end

link "/etc/apache2/mods-enabled/rewrite.load" do
  to "../mods-available/rewrite.load"
end

service "apache2" do
  notifies :restart, "service[apache2]"
end

package "php5 php5-mysql php5-mcrypt" do
  action :install
end

tcxPublic = "#{node['tcxparse']['homedir']}/public"
tcxHost = "#{node['tcxparse']['hostname']}"
template "/etc/apache2/sites-available/default" do
  source "tcxApache.conf.erb"
  mode "0644"
  variables(
    :tcxPublic => tcxPublic,
    :tcxServername => tcxHost
  )
  notifies :restart, "service[apache2]"
end

