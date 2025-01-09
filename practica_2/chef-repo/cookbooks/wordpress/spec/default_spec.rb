require 'chefspec'

describe 'wordpress::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04').converge(described_recipe) }

  it 'creates the WordPress directory' do
    expect(chef_run).to create_directory('/var/www/html/wordpress').with(
      owner: 'www-data',
      group: 'www-data',
      mode: '0755'
    )
  end

  it 'downloads the WordPress archive' do
    expect(chef_run).to create_remote_file('/tmp/wordpress.tar.gz').with(
      source: 'https://wordpress.org/latest.tar.gz'
    )
  end

  it 'extracts the WordPress archive' do
    expect(chef_run).to run_execute('extract_wordpress').with(
      command: 'tar -xzf /tmp/wordpress.tar.gz -C /var/www/html'
    )
  end

  it 'creates the wp-config.php file' do
    expect(chef_run).to create_template('/var/www/html/wordpress/wp-config.php').with(
      owner: 'www-data',
      group: 'www-data',
      mode: '0644'
    )
  end

  it 'restarts the apache2 service after WordPress setup' do
    expect(chef_run).to restart_service('apache2')
  end
end

