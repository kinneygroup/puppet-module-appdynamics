require 'spec_helper'
describe 'appdynamics' do
  context 'with default values for all parameters' do
    it { should compile.with_all_deps }
    it { should contain_class('appdynamics') }

    it do
      should contain_package('libaio').with({
        :ensure => 'installed',
        :before => 'Exec[install_controller]',
      })
    end

    it do
      should contain_package('gcc').with({
        :ensure => 'installed',
        :before => 'Exec[install_controller]',
      })
    end

    limits_entries = {
      'appd_hard_nofile' => 'appd hard nofile 65535',
      'appd_soft_nofile' => 'appd soft nofile 65535',
      'appd_hard_nproc'  => 'appd hard nproc 8192',
      'appd_soft_nproc'  => 'appd soft nproc 8192',
    }

    limits_entries.each do |k, v|
      it do
        should contain_file_line(k).with({
          :path => '/etc/security/limits.conf',
          :line => v,
          :before => 'Exec[install_controller]',
        })
      end
    end

    profile_entries = {
      'appd_ulimit_1' => 'ulimit -n 65535',
      'appd_ulimit_2' => 'ulimit -u 8192',
    }

    profile_entries.each do |k, v|
      it do
        should contain_file_line(k).with({
          :path => '/etc/profile',
          :line => v,
          :before => 'Exec[install_controller]',
        })
      end
    end

    it do
      should contain_file_line('appd_pam_system-auth').with({
        :path   => '/etc/pam.d/system-auth',
        :line   => 'session required pam_limits.so',
        :before => 'Exec[install_controller]',
      })
    end

    response_fixture = File.read(fixtures('response.varfile'))
    it { should contain_file('appdynamics_installer_response').with_content(response_fixture) }

    it do
      should contain_file('appdynamics_installer_response').with({
        :ensure  => 'file',
        :path    => '/tmp/response.varfile',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0644',
        :before  => 'Exec[install_controller]',
      })
    end

    it do
      should contain_exec('install_controller').with({
        :command   => 'sh /tmp/controller.sh -q -varfile /tmp/response.varfile',
        :creates   => '/home/appduser/AppDynamics/Controller',
        :logoutput => true,
        :timeout   => 900,
        :path      => '/bin:/usr/bin:/sbin:/usr/sbin',
      })
    end

    it do
      should contain_exec('install_appd_license').with({
        :command => 'mv /tmp/license.lic /home/appduser/AppDynamics/Controller/license.lic',
        :creates => '/home/appduser/AppDynamics/Controller/license.lic',
        :path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        :require => 'Exec[install_controller]',
      })
    end

    it do
      should contain_file('appdynamics_license').with({
        :ensure  => 'file',
        :path    => '/home/appduser/AppDynamics/Controller/license.lic',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0644',
        :require => 'Exec[install_appd_license]',
      })
    end

    it do
      should contain_exec('install_ha_toolkit').with({
        :command => 'tar -xzvf /tmp/HA-toolkit.tar.gz -C /tmp && mv /tmp/HA-toolkit-* /home/appduser/AppDynamics/Controller/AppDynamicsHA',
        :creates => '/home/appduser/AppDynamics/Controller/AppDynamicsHA',
        :path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        :require => 'Exec[install_controller]',
      })
    end

    it do
      should contain_exec('install_init_script').with({
        :command => 'bash /home/appduser/AppDynamics/Controller/AppDynamicsHA/install-init.sh',
        :creates => '/etc/init.d/appdcontroller',
        :path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        :require => 'Exec[install_ha_toolkit]',
        :notify  => 'Service[appdcontroller]',
      })
    end

    it do
      should contain_service('appdcontroller').with({
        :ensure     => 'running',
        :enable     => true,
        :hasrestart => true,
        :hasstatus  => true,
      })
    end
  end

  describe 'parameter type and content validations' do
    validations = {
      'absolute paths' => {
        :name    => %w(controller_install_path ha_toolkit_path license_path install_dir real_datadir elasticsearch_datadir),
        :valid   => ['/absolute/path'],
        :invalid => ['not/an/absolute/path'],
        :message => 'is not an absolute path',
      },
      'booleans' => {
        :name    => %w(manage_libaio manage_gcc),
        :valid   => [true, 'true', false, 'false'],
        :invalid => ['string', %w(array), { 'ha' => 'sh' }, 3, 2.42],
        :message => '(is not a boolean|Unknown type of boolean given)',
      },
      'integers' => {
        :name    => %w(iio_port server_port admin_port jms_port database_port ssl_port reporting_service_http_port reporting_service_https_port elasticsearch_port install_timeout),
        :valid   => [23],
        :invalid => [true, %w(array), { 'ha' => 'sh' }, 2.42], # validate_integer() accepts integers as strings.
        :message => 'Expected .* to be an Integer',
      },
      # Downgrade for Puppet 3.x: remove fixnum and float from invalid list
      'strings' => {
        :name    => %w(server_hostname language mysql_root_password username password root_user_password exec_path),
        :valid   => ['string'],
        :invalid => [true, %w(array), { 'ha' => 'sh' }],
        :message => 'is not a string',
      },
      'regex for controller_config' => {
        :name    => %w(controller_config),
        :valid   => %w(demo small medium large extra-large),
        :invalid => ['extra-extra'],
        :message => "appdynamics::controller_config is <.*> and valid values are 'demo', 'small', 'medium', 'large' and 'extra-large'",
      },
      'regex for ha_controller_type' => {
        :name    => %w(ha_controller_type),
        :valid   => %w(notapplicable primary secondary),
        :invalid => ['extra-extra'],
        :message => "appdynamics::ha_controller_type is <.*> and valid values are 'notapplicable', 'primary' and 'secondary'",
      },
      'regex for controller_tenancy_mode' => {
        :name    => %w(controller_tenancy_mode),
        :valid   => %w(single multi),
        :invalid => ['extra-extra'],
        :message => "appdynamics::controller_tenancy_mode is <.*> and valid values are 'single' and 'multi'",
      },
    }

    validations.sort.each do |type, var|
      var[:name].each do |var_name|
        var[:params] = {} if var[:params].nil?
        var[:valid].each do |valid|
          context "when #{var_name} (#{type}) is set to valid #{valid} (as #{valid.class})" do
            let(:params) { [var[:params], { :"#{var_name}" => valid, }].reduce(:merge) }
            it { should compile }
          end
        end

        var[:invalid].each do |invalid|
          context "when #{var_name} (#{type}) is set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { [var[:params], { :"#{var_name}" => invalid, }].reduce(:merge) }
            it 'should fail' do
              expect { should contain_class(subject) }.to raise_error(Puppet::Error, /#{var[:message]}/)
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'parameter type content validations'
end
