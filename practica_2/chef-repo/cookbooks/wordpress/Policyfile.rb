# Policyfile.rb - Describe how you want Chef to build your system.
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'wordpress'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list [
  'recipe[apache::default]',
  'recipe[mysql::default]',
  'recipe[php::default]',
  'recipe[wordpress::default]'
]

# Specify a custom source for a single cookbook:
cookbook 'apache', path: '../apache'
cookbook 'mysql', path: '../mysql'
cookbook 'php', path: '../php'
cookbook 'wordpress', path: '.'