# BASE chef/ubuntu-12.04:latest
FROM test_container2
ADD chef/ /etc/chef/
RUN chef-init --bootstrap
RUN rm -rf /etc/chef/secure/*
ENTRYPOINT ["chef-init"]
CMD ["--onboot"]
