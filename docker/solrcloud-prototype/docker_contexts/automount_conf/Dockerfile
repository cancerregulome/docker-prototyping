FROM ubuntu:14.04
COPY startup/automount_drive.sh /tmp/automount_drive.sh
RUN chmod 700 /tmp/automount_drive.sh
CMD ["/tmp/automount_drive.sh"]

# Run instructions:  docker run -d -v /titan/cancerregulome9/workspaces/users/ahahn/docker-prototyping/docker/solrcloud-prototype/data:/data automount_drive