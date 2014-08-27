name             'deployer'
maintainer       'Eucalyptus Systems'
maintainer_email 'vic.iglesias@eucalyptus.com'
license          'Apache 2'
description      'Installs/Configures Deployer jenkins instance'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.7'
depends  'python'
depends  'rbenv'
depends  'ntp'
depends  'cpan'
depends  'java'
