require 'chefspec'

describe 'php::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04').converge(described_recipe) }

  it 'installs the php package' do
    expect(chef_run).to install_package('php')
  end

  it 'installs required PHP extensions' do
    expect(chef_run).to install_package('php-mysql')
    expect(chef_run).to install_package('php-curl')
    expect(chef_run).to install_package('php-xml')
  end

  it 'creates a PHP configuration file' do
    expect(chef_run).to create_template('/etc/php/7.2/apache2/php.ini')
  end
end
