#
# Cookbook Name:: cookbooks/deployer
# Recipe:: deploy
#
# Copyright 2014, Eucalyptus Systems
#
# All rights reserved - Do Not Redistribute
#
include_recipe "python"

package "git"

if platform?("redhat", "centos", "fedora")
    package "libxml2-devel"
    package "libxslt-devel"
  elsif platform?("ubuntu", "debian")
    package "libxml2-dev"
    package "libxslt1-dev"
end

python_pip "paramiko"
python_pip "pychef"
python_pip "fabric"
python_pip "PyYaml"
python_pip "click"
python_pip "argparse"
python_pip "stevedore"
python_pip "sphinx"
