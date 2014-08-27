#
# Cookbook Name:: cookbooks/deployer
# Recipe:: deploy
#
# Copyright 2014, Eucalyptus Systems
#
# All rights reserved - Do Not Redistribute
#
include_recipe "python"

directory "/root/.chef"

template "/root/.chef/knife.rb" do
  source "knife.erb"
end

package "git"

if platform?("redhat", "centos", "fedora")
    package "libxml2-devel"
    package "libxslt-devel"
  elsif platform?("ubuntu", "debian")
    package "libxml2-dev"
    package "libxslt1-dev"
end

include_recipe "rbenv"
include_recipe "rbenv::ruby_build"

mb_ruby_version = "2.1.2"

rbenv_ruby mb_ruby_version do
  global true
  not_if "ls /opt/rbenv/versions/#{mb_ruby_version}"
end

rbenv_execute "gem install motherbrain" do
  ruby_version mb_ruby_version
  timeout 1200
  not_if "ls /opt/rbenv/versions/#{mb_ruby_version}/bin/mb"
end

directory "/root/.mb"

template "/root/.mb/config.json" do
  source "motherbrain.erb"
end

python_pip "paramiko"
python_pip "pychef"
