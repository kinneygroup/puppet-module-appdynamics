# appdynamics

[![Build Status](https://travis-ci.org/kinneygroup/kinneygroup-appdynamics.svg?branch=master)](https://travis-ci.org/kinneygroup/kinneygroup-appdynamics)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with appdynamics](#setup)
    * [What appdynamics affects](#what-appdynamics-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with appdynamics](#beginning-with-appdynamics)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

AppDynamics (https://www.appdynamics.com/) is a solution that provides insight into application performance through application flow maps and transaction monitoring.

## Setup

### Requirements

* AppDynamics controller installer (https://download.appdynamics.com/download/)
* AppDynamics HA Toolkit .tar.gz (https://github.com/Appdynamics/HA-toolkit/releases).
* A valid AppDynamics license
* Port 8090 must be opened on the host firewall to access the web interface

### Installation

```puppet
puppet module install kinneygroup-appdynamics
```

* The controller installer downloaded from AppDynamics  The controller_install_package variable must match the file name.

* Add the license provided by AppDynamics to the "files" directory in the puppet module. The license file name must be license.lic

### Beginning with appdynamics

To perform a basic appdynamics installation, declare the appdynamics class.

```puppet
include appdynamics
```

## Usage

### Basic install

```puppet
class { 'appdynamics':
  password                => 'pa55word',
  controller_install_path => '/opt/appdynamics/controller.sh',
  ha_toolkit_path         => '/opt/appdynamics/ha-toolkit.tar.gz',
  license_path            => '/opt/appdynamics/license.lic'
}
```

### Basic install using hiera

```yaml
appdynamics::password: 'pa55word'
appdynamics::controller_install_path: '/opt/appdynamics/controller.sh'
appdynamics::ha_toolkit_path: '/opt/appdynamics/ha-toolkit.tar.gz'
appdynamics::license_path: '/opt/appdynamics/license.lic'
```

## Reference

The appdynamics module comes with a number of options to interface with appdynamics.

**Classes:**

* appdynamics: The main class

###Parameters

### `controller_install_path`

The path of the controller install package. Valid options: String. Default: '/tmp/controller.sh'.

### `ha_toolkit_path`

The path of the HA toolkit .tar.gz. Valid options: String. Default: '/tmp/HA-toolkit.tar.gz'.

### `license_path`

The path of the license file. Valid options: String. Default: '/tmp/license.lic'.


### `controller_config`

The performance profile type for the instance. Valid options: String. Default: 'demo'.

### `iio_port`

The application server's IIOP port. This port is used for internal system communication. Valid options: String. Default: '3700'.

### `server_port`

The primary HTTP port for the application server. Valid options: Integer. Default: '8090'.

### `server_hostname`

Server host name or IP address that AppDynamics agents and the AppDynamics UI use to connect to the Controller. Valid options: String. Default: '$::fqdn'.

### `ha_controller_type`

The high availability mode for this instance. Valid options: 'notapplicable, primary, secondary' String. Default: 'notapplicable'.

### `controller_tenancy_mode`

The tenancy mode. Valid options: String. Default: 'single'.

### `admin_port`

The application server's administration port. Valid options: Integer. Default: '4848'.

### `language`

The language identifier for the system. Valid options: String. Default: 'en'.

### `jms_port`

The application server's JMS port. Valid options: Integer. Default: '7676'.

### `install_dir`

The controller installatino path. Valid options: String. Default: '/home/appduser/AppDynamics/Controller'.

### `mysql_root_password`

The password of the user account that the Controller uses to access its MySQL database.
Valid options: String. Default: 'changeme'.

### `database_port`

The port for the Controller database. Valid options: Integer. Default: '3388'.

### `username`

The username of the administrator account in the Controller UI. Valid options: String. Default: 'admin'.

### `password`

The admin user password. Valid options: String. Default: 'changeme'.

### `ssl_port`

The secure HTTP port for the application server. Valid options: Integer. Default: '8181'.

### `real_datadir`

The path to the Controller's data directory. Valid options: String. Default: '/home/appduser/AppDynamics/Controller/db/data'.

### `elasticsearch_datadir`

The path to the Elastic Search file store. Valid options: String.
Default: '/home/appduser/AppDynamics/Controller/events_service/analytics-processor'.

### `root_user_password`

The Controller root user password. The root user is a Controller user account with privileges for accessing the system Administration Console.
Valid options: String. Default: 'pa55word2'.

### `reporting_service_http_port`

The reporting service HTTP port. This port is used for internal system communication.
Valid options: Integer. Default: '8020'.

### `reporting_service_https_port`

The reporting service HTTPS port. This port is used for internal system communication.
Valid options: Integer. Default: '8021'.

### `elasticsearch_port`

The port on which the Elastic Search process listens. This port is used for internal system communication.
Valid options: Integer. Default: '9200'.

### `install_timeout`

The controller installation timeout determines the amount of time to wait for the installation to complete
before timing out.
Valid options: Integer. Default '900'

### `exec_path`

The system executable path.
Valid options: String. Default '/bin:/usr/bin:/sbin:/usr/sbin'

### `manage_libaio`

Appdynamics requires the libaio package to be installed on the system, this setting determines whether this module
should manage the installation of the gcc package or to allow another module to manage it. This setting helps to
avoid duplicate resource declarations.
Valid options: boolean. Default: 'true'.

### `manage_gcc`

Appdynamics requires the gcc package to be installed on the system, this setting determines whether this module
should manage the installation of the gcc package or to allow another module to manage it. This setting helps to
avoid duplicate resource declarations.
Valid options: boolean. Default: 'true'.

## Limitations

Currently, the appdynamics module is tested on the following operating systems:

* CentOS 7

The module currently does not support an automated HA or Multitenant deployment.

## Development

Contributions to the module are welcome and appreciated. The following guidelines are required
for any code to be merged.

* All code must have corresponding rspec tests where possible.
* Any additional variables or classes that are added must be documented in the readme.
* All TravisCI tests must pass.
