FROM chef/ubuntu-14.04
RUN apt-get -qq update
RUN apt-get -qq install build-essential python-django nano
RUN apt-get -qq clean
RUN export PATH=/usr/lib/python2.7/dist-packages/django/bin:$PATH
RUN chmod u+x /usr/lib/python2.7/dist-packages/django/bin/django-admin.py
RUN /usr/lib/python2.7/dist-packages/django/bin/django-admin.py startproject test_app
RUN chmod u+x /test_app/manage.py
EXPOSE 8000
ENTRYPOINT python
CMD ["test_app/manage.py", "runserver"]
