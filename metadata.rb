name 'mongodb-cluster'
maintainer 'Colin Hubert'
maintainer_email 'chubert@turbine.com'
license 'Apache 2.0'
description 'Vagrant cluster of MongoDB servers'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.0'

supports 'ubuntu'

depends 'mongodb'
