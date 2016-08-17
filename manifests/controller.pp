# == Class: appdynamics::controller
#
class appdynamics::controller (
  $controller_install_package   = $appdynamics::params::controller_install_package,
  $controller_config            = $appdynamics::params::controller_config,
  $iio_port                     = $appdynamics::params::iio_port,
  $server_port                  = $appdynamics::params::server_port,
  $server_hostname              = $appdynamics::params::server_hostname,
  $ha_controller_type           = $appdynamics::params::ha_controller_type,
  $controller_tenancy_mode      = $appdynamics::params::controller_tenancy_mode,
  $admin_port                   = $appdynamics::params::admin_port,
  $language                     = $appdynamics::params::language,
  $jms_port                     = $appdynamics::params::jms_port,
  $install_dir                  = $appdynamics::params::install_dir,
  $mysql_root_password          = $appdynamics::params::mysql_root_password,
  $database_port                = $appdynamics::params::database_port,
  $username                     = $appdynamics::params::username,
  $password                     = $appdynamics::params::password,
  $ssl_port                     = $appdynamics::params::ssl_port,
  $real_datadir                 = $appdynamics::params::real_datadir,
  $elasticsearch_datadir        = $appdynamics::params::elasticsearch_datadir,
  $disable_eula                 = $appdynamics::params::disable_eula,
  $root_user_password           = $appdynamics::params::root_user_password,
  $reporting_service_http_port  = $appdynamics::params::reporting_service_http_port,
  $reporting_service_https_port = $appdynamics::params::reporting_service_https_port,
  $elasticsearch_port           = $appdynamics::params::elasticsearch_port,
  ) inherits appdynamics::params {

    Package['libaio'] ->
    File_line['appd hard nofile'] ->
    File_line['appd soft nofile'] ->
    File_line['appd hard nproc'] ->
    File_line['appd soft nproc'] ->
    File_line['ulimit config 1'] ->
    File_line['ulimit config 2'] ->
    File['deploy response file'] ->
    Exec['install app dynamics controller']
    Package['gcc'] ->
    File['Deploy HA Toolkit'] ->
    Exec['Install init'] ->
    Service['appdcontroller']

    package { 'libaio':
      ensure => installed,
    }

    file_line { 'appd hard nofile':
      path => '/etc/security/limits.conf',
      line => 'appd hard nofile 65535',
    }

    file_line { 'appd soft nofile':
      path => '/etc/security/limits.conf',
      line => 'appd soft nofile 65535',
    }

    file_line { 'appd hard nproc':
      path => '/etc/security/limits.conf',
      line => 'appd hard nproc 8192',
    }

    file_line { 'appd soft nproc':
      path => '/etc/security/limits.conf',
      line => 'appd soft nproc 8192',
    }

    file_line { 'ulimit config 1':
      path => '/etc/profile',
      line => 'ulimit -n 65535',
    }

    file_line { 'ulimit config 2':
      path => '/etc/profile',
      line => 'ulimit -u 8192',
    }

    file_line { 'pam configuration':
      path => '/etc/pam.d/system-auth',
      line => 'session required pam_limits.so',
    }

    file { 'deploy response file':
      ensure  => file,
      mode    => '0644',
      content => template('appdynamics/response.varfile.erb'),
      path    => '/opt/response.varfile',
    }

    file { 'deploy controller package':
      ensure => file,
      mode   => '0755',
      path   => "/opt/${controller_install_package}",
      source => "puppet:///modules/appdynamics/${controller_install_package}",
    }

    exec { 'install app dynamics controller':
      command   => "sh /opt/${controller_install_package} -q -varfile /opt/response.varfile",
      creates   => '/home/appduser/AppDynamics/Controller/bin/controller.sh',
      require   => File['deploy response file','deploy controller package'],
      logoutput => true,
      provider  => shell,
    }

    file { 'appdynamics license':
      ensure  => file,
      mode    => '0644',
      path    => "${install_dir}/license.lic",
      source  => 'puppet:///modules/appdynamics/license.lic',
      require => Exec['install app dynamics controller'],
    }

    package { 'gcc':
      ensure => installed,
    }

    file { 'Deploy HA Toolkit':
      ensure  => directory,
      mode    => '0644',
      source  => 'puppet:///modules/appdynamics/AppDynamicsHA',
      recurse => true,
      path    => "${install_dir}/AppDynamicsHA",
    }

    exec { 'Install init':
      command  => "bash ${install_dir}/AppDynamicsHA/install-init.sh",
      creates  => '/etc/init.d/appdcontroller',
      provider => shell,
    }

    service { 'appdcontroller':
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
    }
}
