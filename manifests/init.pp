# == Class: appdynamics
#
class appdynamics (
  $controller_install_path      = '/tmp/controller.sh',
  $ha_toolkit_path              = '/tmp/HA-toolkit.tar.gz',
  $license_path                 = '/tmp/license.lic',
  $controller_config            = 'demo',
  $iio_port                     = 3700,
  $server_port                  = 8090,
  $server_hostname              = $::fqdn,
  $ha_controller_type           = 'notapplicable',
  $controller_tenancy_mode      = 'single',
  $admin_port                   = 4848,
  $language                     = 'en',
  $jms_port                     = 7676,
  $install_dir                  = '/home/appduser/AppDynamics/Controller',
  $mysql_root_password          = 'changeme',
  $database_port                = 3388,
  $username                     = 'admin',
  $password                     = 'changeme',
  $ssl_port                     = 8181,
  $real_datadir                 = '/home/appduser/AppDynamics/Controller/db/data',
  $elasticsearch_datadir        = '/home/appduser/AppDynamics/Controller/events_service/analytics-processor',
  $root_user_password           = 'changeme',
  $reporting_service_http_port  = 8020,
  $reporting_service_https_port = 8021,
  $elasticsearch_port           = 9200,
  $install_timeout              = 900,
  $exec_path                    = '/bin:/usr/bin:/sbin:/usr/sbin',
  $manage_libaio                = true,
  $manage_gcc                   = true,
) {

  validate_absolute_path($controller_install_path)
  validate_absolute_path($ha_toolkit_path)
  validate_absolute_path($license_path)
  validate_re($controller_config, '^(demo|small|medium|large|extra-large)$',
    "appdynamics::controller_config is <${controller_config}> and valid values are 'demo', 'small', 'medium', 'large' and 'extra-large'.")

  validate_integer($iio_port)
  validate_integer($server_port)
  validate_string($server_hostname)
  validate_re($ha_controller_type, '^(notapplicable|primary|secondary)$',
    "appdynamics::ha_controller_type is <${ha_controller_type}> and valid values are 'notapplicable', 'primary' and 'secondary'.")

  validate_re($controller_tenancy_mode, '^(single|multi)$',
    "appdynamics::controller_tenancy_mode is <${controller_tenancy_mode}> and valid values are 'single' and 'multi'.")

  validate_integer($admin_port)
  validate_string($language)
  validate_integer($jms_port)
  validate_absolute_path($install_dir)
  validate_string($mysql_root_password)
  validate_integer($database_port)
  validate_string($username)
  validate_string($password)
  validate_integer($ssl_port)
  validate_absolute_path($real_datadir)
  validate_absolute_path($elasticsearch_datadir)
  validate_string($root_user_password)
  validate_integer($reporting_service_http_port)
  validate_integer($reporting_service_https_port)
  validate_integer($elasticsearch_port)
  validate_integer($install_timeout)
  validate_string($exec_path)

  if is_string($manage_libaio) == true {
    $manage_libaio_real = str2bool($manage_libaio)
  } else {
    $manage_libaio_real = $manage_libaio
  }
  validate_bool($manage_libaio_real)

  if is_string($manage_gcc) == true {
    $manage_gcc_real = str2bool($manage_gcc)
  } else {
    $manage_gcc_real = $manage_gcc
  }
  validate_bool($manage_gcc_real)

  if $manage_libaio == true {
    package { 'libaio':
      ensure => installed,
      before => Exec['install_controller'],
    }
  }

  if $manage_gcc == true {
    package { 'gcc':
      ensure => installed,
      before => Exec['install_controller'],
    }
  }

  File_line {
    before => Exec['install_controller'],
  }

  file_line { 'appd_hard_nofile':
    path => '/etc/security/limits.conf',
    line => 'appd hard nofile 65535',
  }

  file_line { 'appd_soft_nofile':
    path => '/etc/security/limits.conf',
    line => 'appd soft nofile 65535',
  }

  file_line { 'appd_hard_nproc':
    path => '/etc/security/limits.conf',
    line => 'appd hard nproc 8192',
  }

  file_line { 'appd_soft_nproc':
    path => '/etc/security/limits.conf',
    line => 'appd soft nproc 8192',
  }

  file_line { 'appd_ulimit_1':
    path => '/etc/profile',
    line => 'ulimit -n 65535',
  }

  file_line { 'appd_ulimit_2':
    path => '/etc/profile',
    line => 'ulimit -u 8192',
  }

  file_line { 'appd_pam_system-auth':
    path => '/etc/pam.d/system-auth',
    line => 'session required pam_limits.so',
  }

  file { 'appdynamics_installer_response':
    ensure  => 'file',
    path    => '/tmp/response.varfile',
    content => template('appdynamics/response.varfile.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    before  => Exec['install_controller'],
  }

  exec { 'install_controller':
    command   => "sh ${controller_install_path} -q -varfile /tmp/response.varfile",
    creates   => '/home/appduser/AppDynamics/Controller',
    logoutput => true,
    timeout   => $install_timeout,
    path      => $exec_path,
  }

  exec { 'install_appd_license':
    command => "mv ${license_path} ${install_dir}/license.lic",
    creates => "${install_dir}/license.lic",
    path    => $exec_path,
    require => Exec['install_controller'],
  }

  file { 'appdynamics_license':
    ensure  => 'file',
    path    => "${install_dir}/license.lic",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Exec['install_appd_license'],
  }

  exec { 'install_ha_toolkit':
    command => "tar -xzvf ${ha_toolkit_path} -C /tmp && mv /tmp/HA-toolkit ${install_dir}/AppDynamicsHA",
    creates => "${install_dir}/AppDynamicsHA",
    path    => $exec_path,
    require => Exec['install_controller'],
  }

  exec { 'install_init_script':
    command => "bash ${install_dir}/AppDynamicsHA/install-init.sh",
    creates => '/etc/init.d/appdcontroller',
    path    => $exec_path,
    require => Exec['install_ha_toolkit'],
    notify  => Service['appdcontroller'],
  }

  service { 'appdcontroller':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
}
