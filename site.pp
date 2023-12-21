if versioncmp($::puppetversion,'3.6.1') >= 0 {

  $allow_virtual_packages = hiera('allow_virtual_packages',false)

  Package {
    allow_virtual => $allow_virtual_packages,
  }
}

class yum {
  exec { "yum-update":
    command => "/bin/yum -y -q update"
  }
}

class docker {
   yumrepo { "docker-ce-stable":
      name=Docker CE Stable - $basearch,
      baseurl=https://download.docker.com/linux/centos/$releasever/$basearch/stable,
      enabled=1,
      gpgcheck=1,
      gpgkey=https://download.docker.com/linux/centos/gpg
   }
}

node 'default' {

  # define stages
  stage {
    'pre' : ;
    'post': ;
  }

  # specify stage that each class belongs to;
  # if not specified, they belong to Stage[main]
  class {
    'yum':         stage => 'pre';
    'docker':      stage => 'pre';
  }

  # stage order
  Stage['pre'] -> Stage[main] -> Stage['post']

  # modules
  include hysds_dev
  include hysds_base
  include scientific_python

}
