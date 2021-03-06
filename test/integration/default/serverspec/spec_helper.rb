require 'serverspec'
require 'pathname'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.os = backend(Serverspec::Commands::Base).check_os
    if ENV['ASK_SUDO_PASSWORD']
      require 'highline/import'
      c.sudo_password = ask("Enter sudo password: ") { |q| q.echo = false }
    else
      c.sudo_password = ENV['SUDO_PASSWORD']
    end
  end
end
