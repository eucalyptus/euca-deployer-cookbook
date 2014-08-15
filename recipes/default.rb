#
# Cookbook Name:: cookbooks/micro-qa
# Recipe:: default
#
# Copyright 2014, Eucalyptus Systems
#
# All rights reserved - Do Not Redistribute
#

include_recipe "deployer::deploy"
include_recipe "deployer::eutester"
