admin_user="admin" 
admin_password="password"
url: http://localhost:8081/wp-login.php


Ejecución de test
    Unitarios:
        Ejecución de cada una 

        chef exec rspec chef-repo/cookbooks/apache/spec/default_spec.rb
        chef exec rspec chef-repo/cookbooks/mysql/spec/default_spec.rb
        chef exec rspec chef-repo/cookbooks/php/spec/default_spec.rb
        chef exec rspec chef-repo/cookbooks/wordpress/spec/default_spec.rb

        Ejecución conjunta:

        chef exec rspec 'chef-repo/cookbooks/*/spec/*_spec.rb'

    Integración:
        