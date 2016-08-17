# == Class: appdynamics::params
#
# Default parameter values for the appdynamics module
#

class appdynamics::params (){

  # Controller Settings
  $controller_install_package      = 'controller.sh'
  $controller_config               = 'demo'
  $iio_port                        = '3700'
  $server_port                     = '8090'
  $server_hostname                 = $::fqdn
  $ha_controller_type              = 'notapplicable'
  $controller_tenancy_mode         = 'single'
  $admin_port                      = '4848'
  $language                        = 'en'
  $jms_port                        = '7676'
  $install_dir                     = '/home/appduser/AppDynamics/Controller'
  $mysql_root_password             = 'DRvYYv9eq6'
  $database_port                   = '3388'
  $username                        = 'admin'
  $password                        = 'pa55word'
  $ssl_port                        = '8181'
  $real_datadir                    = '/home/appduser/AppDynamics/Controller/db/data'
  $elasticsearch_datadir           = '/home/appduser/AppDynamics/Controller/events_service/analytics-processor'
  $disable_eula                    = 'true'
  $root_user_password              = 'pa55word2'
  $reporting_service_http_port     = '8020'
  $reporting_service_https_port    = '8021'
  $elasticsearch_port              = '9200'

}
