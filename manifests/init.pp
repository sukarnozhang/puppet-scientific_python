#####################################################
# scientific_python class
#####################################################

class scientific_python {

  #####################################################
  # create groups and users
  #####################################################
  $user = 'ops'
  $group = 'ops'
  $docker_group = 'docker'

  group { $group:
    ensure     => present,
  }

  user { $user:
    ensure     => present,
    gid        => $group,
    groups     => [ $docker_group ],
    shell      => '/bin/bash',
    home       => "/home/$user",
    managehome => true,
    require    => [
                   Group[$group],
                  ],
  }


  file { "/home/$user":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => 0755,
    require => User[$user],
  }


  file { "/etc/sudoers.d/90-cloudimg-$user":
    ensure  => file,
    content  => template('scientific_python/90-cloudimg-user'),
    mode    => 0440,
    require => [
                User[$user],
               ],
  }


  #####################################################
  # add .inputrc to users' home
  #####################################################

  inputrc { 'root':
    home => '/root',
  }
  
  inputrc { $user:
    home    => "/home/$user",
    require => User[$user],
  }


  #####################################################
  # change default user
  #####################################################

  file_line { "default_user":
    ensure  => present,
    line    => "    name: $user",
    path    => "/etc/cloud/cloud.cfg",
    match   => "^    name:",
    require => User[$user],
  }


  #####################################################
  # install .bashrc
  #####################################################

  file { "/home/$user/.bashrc":
    ensure  => present,
    content => template('scientific_python/bashrc'),
    owner   => $user,
    group   => $group,
    mode    => 0644,
    require => User[$user],
  }


  file { "/root/.bashrc":
    ensure  => present,
    content => template('scientific_python/bashrc'),
    mode    => 0600,
  }


  #####################################################
  # install packages
  #####################################################

  yumgroup { 'Development tools':
    ensure  => present,
  }


  package {
    'screen': ensure => installed;
    'bind-utils': ensure => installed;
    'curl': ensure => installed;
    'wget': ensure => installed;
    'vim-enhanced': ensure => installed;
    'nscd': ensure => installed;
    'chrony': ensure => installed;
    'git': ensure => installed;
    'subversion': ensure => installed;
    'python': ensure => present;
    'python-devel': ensure => present;
    'python-virtualenv': ensure => present;
    'compat-libf2c-34': ensure => installed;
    'freetype-devel': ensure => present;
    'libpng12-devel': ensure => present;
    'readline-devel': ensure => installed;
    'libxml2-devel': ensure => installed;
    'libxslt-devel': ensure => installed;
    'libuuid-devel': ensure => installed;
    'blas-devel': ensure => installed;
    'liblas-devel': ensure => installed;
    'lapack-devel': ensure => installed;
    'lapack64-devel': ensure => installed;
    'libcurl-devel': ensure => installed;
    'sqlite-devel': ensure => installed;
    'graphviz-devel': ensure => installed;
    'ImageMagick-devel': ensure => installed;
    'geos-devel': ensure => installed;
    'proj-devel': ensure => installed;
    'openssl-devel': ensure => installed;
    'hdf-devel': ensure => installed;
    'hdf5-devel': ensure => installed;
    'netcdf-devel': ensure => installed;
    'xerces-c-devel': ensure => installed;
    'xqilla-devel': ensure => installed;
    'zlib-devel': ensure => installed;
    'libdb4-devel': ensure => installed;
    'libdb4-utils': ensure => installed;
    'openldap-devel': ensure => installed;
    'tk-devel': ensure => installed;
    'python-setuptools': ensure => present;
    'python2-pip': ensure => present;
    'numpy': ensure => installed;
    'numpy-f2py': ensure => installed;
    'netcdf4-python': ensure => installed;
    'python-matplotlib': ensure => installed;
    'python-matplotlib-tk': ensure => installed;
    'python-basemap': ensure => installed;
    'python-basemap-data': ensure => installed;
    'python-tables': ensure => installed;
    'python2-numexpr': ensure => installed;
    'scipy': ensure => installed;
    'python-lxml': ensure => installed;
    'python-fpconst': ensure => installed;
    'm2crypto': ensure => installed;
    'Cython': ensure => installed;
    'python-pillow': ensure => installed;
    'python-pillow-devel': ensure => installed;
    'python-crypto': ensure => installed;
    'python-paramiko': ensure => installed;
    'python-formencode': ensure => installed;
    'python-sqlalchemy': ensure => installed;
    'python-sqlobject': ensure => installed;
    'python-ipython': ensure => installed;
    'h5py': ensure => installed;
    'python-twisted-core': ensure => installed;
    'python-twisted-web': ensure => installed;
    'python-twisted-words': ensure => installed;
    'geos-python': ensure => installed;
    'pyshp': ensure => installed;
    'libxml2-python': ensure => installed;
    'libxslt-python': ensure => installed;
    'SOAPpy': ensure => installed;
    'supervisor': ensure => installed;
    'pbzip2': ensure => installed;
    'pigz': ensure => installed;
    'docker-ce': ensure => installed;
    'yum-utils': ensure => installed;
    'device-mapper-persistent-data': ensure => installed;
    'lvm2': ensure => installed;
  }


  #####################################################
  # link vim
  #####################################################
  update_alternatives { 'vi':
    link     => '/bin/vi',
    path     => '/bin/vim',
    priority => 1,
    require  => Package['vim-enhanced'],
  }


  #####################################################
  # refresh ld cache
  #####################################################

  if ! defined(Exec['ldconfig']) {
    exec { 'ldconfig':
      command     => '/sbin/ldconfig',
      refreshonly => true,
    }
  }
  

  #####################################################
  # link sciflo data area
  #####################################################
  file { '/data':
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => 0775,
  }


  #####################################################
  # install home baked packages for sciflo and hysds
  #####################################################

  package { 'tsunami-udp':
    provider => rpm,
    ensure   => present,
    source   => "/etc/puppet/modules/scientific_python/files/tsunami-udp-1.1b43-1.x86_64.rpm",
    notify   => Exec['ldconfig'],
  }

  package { 'dbxml':
    provider => rpm,
    ensure   => present,
    source   => "/etc/puppet/modules/scientific_python/files/dbxml-6.0.18-1.x86_64.rpm",
    require  => Package['xqilla-devel'],
    notify   => Exec['ldconfig'],
  }

  package { 'hdfeos':
    provider => rpm,
    ensure   => present,
    source   => "/etc/puppet/modules/scientific_python/files/hdfeos-2.19-1.x86_64.rpm",
    require  => Package['hdf-devel'],
    notify   => Exec['ldconfig'],
  }

#  package { 'openssl-sciflo':
#    provider => dpkg,
#    ensure   => present,
#    source   => "/etc/puppet/modules/scientific_python/files/openssl-sciflo_0.9.7d-1_amd64.deb",
#    notify   => Exec['ldconfig'],
#  }
#
  easy_install { 'bsddb3':
    name    => '/etc/puppet/modules/scientific_python/files/bsddb3-6.1.0-py2.7-linux-x86_64.egg',
    ensure  => installed,
    require => [
                Package['python-setuptools'],
                Package['dbxml'],
               ],
  }

  easy_install { 'python-dbxml':
    name    => '/etc/puppet/modules/scientific_python/files/dbxml-6.0.18-py2.7-linux-x86_64.egg',
    ensure  => installed,
    require => [
                Package['python-setuptools'],
                Package['dbxml'],
                Easy_install['bsddb3'],
               ],
  }

  easy_install { 'python-pyxml':
    name    => '/etc/puppet/modules/scientific_python/files/PyXML-0.8.4-py2.7-linux-x86_64.egg',
    ensure  => installed,
    require => Package['python-setuptools'],
  }
  
  easy_install { 'python-numeric':
    name    => '/etc/puppet/modules/scientific_python/files/Numeric-24.2-py2.7-linux-x86_64.egg',
    ensure  => installed,
    require => Easy_install['python-pyxml'],
  }
  
  easy_install { 'python-hdfeos':
    name    => '/etc/puppet/modules/scientific_python/files/hdfeos-0.5-py2.7-linux-x86_64.egg',
    ensure  => installed,
    require => Easy_install['python-numeric'],
  }
  
  easy_install { 'python-polygon':
    name    => '/etc/puppet/modules/scientific_python/files/Polygon-1.13-py2.7-linux-x86_64.egg',
    ensure  => installed,
    require => Easy_install['python-hdfeos'],
  }
  
  easy_install { 'python-numarray':
    name    => '/etc/puppet/modules/scientific_python/files/numarray-1.5.2-py2.7-linux-x86_64.egg',
    ensure  => installed,
    require => Easy_install['python-polygon'],
  }
  
  easy_install { 'python-pyhdf':
    name    => '/etc/puppet/modules/scientific_python/files/pyhdf-0.8.3-py2.7-linux-x86_64.egg',
    ensure  => installed,
    require => Easy_install['python-numarray'],
  }
  
  easy_install { 'python-processing':
    name    => '/etc/puppet/modules/scientific_python/files/processing-0.39-py2.7-linux-x86_64.egg',
    ensure  => installed,
    require => Easy_install['python-pyhdf'],
  }


}
