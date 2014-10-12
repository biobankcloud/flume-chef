require 'spec_helper'

describe service('flume') do  
  it { should be_enabled   }
  it { should be_running   }
end 


describe file('/var/log/flume/flume.log') do
  it { should be_file }
  its(:content) { should match /started/ }
end
