# == Class: appdynamics
#
class appdynamics (
  $controller_install_package      = $appdynamics::params::controller_install_package,
  $controller_config               = $appdynamics::params::controller_config,
  $iio_port                        = $appdynamics::params::iio_port,
  $server_port                     = $appdynamics::params::server_port,
  $server_hostname                 = $appdynamics::params::server_hostname,
  $ha_controller_type              = $appdynamics::params::ha_controller_type,
  $controller_tenancy_mode         = $appdynamics::params::controller_tenancy_mode,
  $admin_port                      = $appdynamics::params::admin_port,
  $language                        = $appdynamics::params::language,
  $jms_port                        = $appdynamics::params::jms_port,
  $install_dir                     = $appdynamics::params::install_dir,
  $mysql_root_password             = $appdynamics::params::mysql_root_password,
  $database_port                   = $appdynamics::params::database_port,
  $username                        = $appdynamics::params::username,
  $password                        = $appdynamics::params::password,
  $ssl_port                        = $appdynamics::params::ssl_port,
  $real_datadir                    = $appdynamics::params::real_datadir,
  $elasticsearch_datadir           = $appdynamics::params::elasticsearch_datadir,
  $disable_eula                    = $appdynamics::params::disable_eula,
  $root_user_password              = $appdynamics::params::root_user_password,
  $reporting_service_http_port     = $appdynamics::params::reporting_service_http_port,
  $reporting_service_https_port    = $appdynamics::params::reporting_service_https_port,
  $elasticsearch_port              = $appdynamics::params::elasticsearch_port,
  ) inherits appdynamics::params {

  validate_string($controller_install_package)
  validate_re($controller_config, '^demo$|^small$|^medium$|^large$|^extra-large$', 'The controller config must be set to demo, small, medium, large, or extra-large')
  validate_string($iio_port)
  validate_string($server_port)
  validate_string($server_hostname)
  validate_re($ha_controller_type, '^notapplicable$|^primary$|^secondary$', 'The HA Controller type must be "notapplicable", "primary", or "secondary"')
  validate_re($controller_tenancy_mode, '^single$|^multi$', 'The controller tenancy mode must be set to single or multi')
  validate_string($admin_port)
  validate_string($language)
  validate_string($jms_port)
  validate_string($install_dir)
  validate_string($mysql_root_password)
  validate_string($database_port)
  validate_string($username)
  validate_string($password)
  validate_string($ssl_port)
  validate_string($real_datadir)
  validate_string($elasticsearch_datadir)
  validate_string($disable_eula)
  validate_string($root_user_password)
  validate_string($reporting_service_http_port)
  validate_string($reporting_service_https_port)
  validate_string($elasticsearch_port)
}
