include_recipe "ntp"

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

share_tarball = "#{share_directory}/jenkins-share-v1.tgz"
remote_file share_tarball do
  source "http://jenkins-share.walrus.cloud.qa1.eucalyptus-systems.com:8773/jenkins-share-v1.tgz"
end

execute "tar xzfv #{share_tarball}" do
  cwd share_directory
end

bash "Pull in latest EucaTest repo" do
  user "root"
  cwd share_directory
  code <<-EOH
  pushd perl_lib/EucaTest
  git remote rm origin
  git remote add origin https://github.com/viglesiasce/EucaTest.git
  git stash
  git pull origin master
  popd
  EOH
end

bash "Refresh eutester virtualenv" do
  user "root"
  cwd share_directory
  code <<-EOH
  rm -rf eutester-base/
  virtualenv eutester-base
  source eutester-base/bin/activate
  pushd eutester
  python setup.py install
  popd
  deactivate
  EOH
end
