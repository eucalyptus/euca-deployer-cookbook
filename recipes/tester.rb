include_recipe "ntp"

bash "Add internal git repo ssh key" do
  code <<-EOH
  if ! grep git.eucalyptus-systems.com /root/.ssh/known_hosts;then
       ssh-keyscan git.eucalyptus-systems.com >> /root/.ssh/known_hosts
  fi
  EOH
end

%w{wget unzip apache-ivy ant-junit ant-trax}.each do |package_name|
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
%w{Net::OpenSSH}.each do |module_name|
  cpan_client module_name do
      action 'install'
      install_type 'cpan_module'
  end
end

eutester_base_directory = "#{share_directory}/eutester-base"
python_virtualenv eutester_base_directory
python_pip "eutester" do
  virtualenv eutester_base_directory
  action :install
end
