
require 'spec_helper'
describe 'appdynamics' do

  context 'with defaults for all parameters' do
    it { should contain_class('appdynamics') }
  end
end
