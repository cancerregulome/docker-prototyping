ENV['DJANGO_PATH'] = '/usr/lib/python2.7/dist-packages/django/bin'

execute "apt-get -qq update"

apt_package "build-essential" do
	action :install
end

apt_package "python-django" do 
	action :install
end

bash "django_setup" do
	code <<-EOH
	apt-get -qq clean
	chmod u+x $DJANGO_PATH/django-admin.py
	$DJANGO_PATH/django-admin.py startproject test_app
	chmod u+x test_app/manage.py
	python test_app/manage.py runserver 0.0.0.0:8000
	EOH
end	
	


