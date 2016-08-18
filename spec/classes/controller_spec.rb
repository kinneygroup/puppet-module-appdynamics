equire 'spec_helper'

describe 'appdynamics::controller', :type => :class do


  describe 'appdcontroller service' do
  it do
    should contain_service('appdcontroller').with(
      'ensure'     => 'running',
      'enable'     => 'true',
      'hasrestart' => 'true',
      'hasstatus'  => 'true',
    )
  end
end


end
