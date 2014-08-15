require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "Deployer" do
  describe command('ruby -v') do
    it { should match /2.1.2/ }
  end
  
  describe command('mb version') do
    it { should return_exit_status 0 }
  end 
end
