# BASE chef/ubuntu-12.04:latest
FROM test_container
ADD chef/ /etc/chef/
RUN ls /etc/chef/secure/trusted_certs
RUN chef-init --bootstrap
RUN rm -rf /etc/chef/secure/*
ENTRYPOINT ["chef-init"]
CMD ["--onboot"]
