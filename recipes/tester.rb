include_recipe "ntp"

%w{git.qa1.eucalyptus-systems.com git.eucalyptus-systems.com}.each do |host|
  bash "Add internal git repo ssh key" do
    code <<-EOH
    if ! grep #{host} /root/.ssh/known_hosts;then
         ssh-keyscan #{host} >> /root/.ssh/known_hosts
    fi
    EOH
  end
end

%w{wget unzip apache-ivy ant-junit ant}.each do |package_name|
  package package_name
end

### Symlink for ivy
execute "ln -fs /usr/share/java/ivy-2.3.0.jar /usr/share/ant/lib/ivy-2.3.0.jar"

share_directory = "/share"
directory share_directory

eutester_directory = "#{share_directory}/eutester"
git eutester_directory do
  repository node['eutester']['git-repository']
  revision node['eutester']['git-revision']
  action :sync
end

execute 'python setup.py install' do
  cwd eutester_directory
end

package "perl-CPAN"
perl_directory = "#{share_directory}/perl_lib"
directory perl_directory
eucatest_directory = "#{perl_directory}/EucaTest"
git eucatest_directory do
  repository node['EucaTest']['git-repository']
  revision node['EucaTest']['git-revision']
  action :sync
end
%w{Net::OpenSSH Time::HiRes IO::Pty}.each do |module_name|
  cpan_client module_name do
      action 'install'
      install_type 'cpan_module'
  end
end
execute "Symlink EucaTest into path" do
  command "ln -sf #{eucatest_directory}/lib/EucaTest.pm /usr/lib64/perl5/EucaTest.pm"
end

eutester_base_directory = "#{share_directory}/eutester-base"
python_virtualenv eutester_base_directory
python_pip "eutester" do
  virtualenv eutester_base_directory
  options "--pre"
  action :install
end

# We need to update nss package on tester slaves due to JDK7 SSL issue that
# caused eutester4j suite to fail when trying to fetch YouAreSDK
# More info at http://blog.backslasher.net/java-ssl-crash.html
package 'nss' do
  action :upgrade
end
