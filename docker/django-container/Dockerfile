FROM chef/ubuntu-14.04
RUN apt-get -qq update
RUN apt-get -qq install build-essential python-django
RUN apt-get -qq clean
ENV DJANGO /usr/lib/python2.7/dist-packages/django/bin
RUN chmod u+x $DJANGO/django-admin.py
RUN $DJANGO/django-admin.py startproject test_app
RUN chmod u+x /test_app/manage.py
EXPOSE 8000
CMD ["python", "test_app/manage.py", "runserver", "0.0.0.0:8000"]
