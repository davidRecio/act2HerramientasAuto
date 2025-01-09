require 'chefspec'

describe 'mysql::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04').converge(described_recipe) }

  it 'installs the mysql-server package' do
    expect(chef_run).to install_package('mysql-server')
  end

  it 'enables the mysql service' do
    expect(chef_run).to enable_service('mysql')
  end

  it 'starts the mysql service' do
    expect(chef_run).to start_service('mysql')
  end

  it 'creates a configuration file for MySQL' do
    expect(chef_run).to create_template('/etc/mysql/my.cnf')
  end
end
