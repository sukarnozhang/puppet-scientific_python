#####################################################
# scientific_python class
#####################################################

class scientific_python inherits hysds_dev {

  #####################################################
  # install packages
  #####################################################

  package {
    'screen': ensure => installed;
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
    'openssl-devel': ensure => installed;
    'hdf-devel': ensure => installed;
    'hdf5-devel': ensure => installed;
    'netcdf-devel': ensure => installed;
    'xerces-c-devel': ensure => installed;
    'xqilla-devel': ensure => installed;
    'zlib-devel': ensure => installed;
    'libdb4-devel': ensure => installed;
    'libdb4-utils': ensure => installed;
    'tk-devel': ensure => installed;
    'python-setuptools': ensure => present;
    'python2-pip': ensure => present;
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
  }


  #####################################################
  # start docker service
  #####################################################

  service { 'docker':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [
                   Package['docker-ce'],
                  ],
  }


}
