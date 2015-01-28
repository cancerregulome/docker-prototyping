FROM test-container1
ADD chef /etc/chef
ONBUILD RUN apt-get -qq update
ONBUILD RUN apt-get -qq install build-essential python-django
ONBUILD RUN apt-get -qq clean
ONBUILD ENV DJANGO /usr/lib/python2.7/dist-packages/django/bin
ONBUILD RUN chmod u+x $DJANGO/django-admin.py
ONBUILD RUN $DJANGO/django-admin.py startproject test_app
ONBUILD RUN chmod u+x /test_app/manage.py
ONBUILD EXPOSE 8000
ONBUILD ENTRYPOINT ["chef-init"]
ONBUILD CMD ["--onboot"]

