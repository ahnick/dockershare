# Dockershare

Dockershare provides a convenient way to expose a container's filesystem as a SMB/CIFS share.  It does this by running Samba inside a Docker container and providing a script to symlink to another container's filesystem on the same host.  Note, that the CoW filesystem of the container is being exposed here, rather than a volume on the host.  This is intentionally done, so that changes made over the share (e.g. via an editior or IDE) can be saved by running a simple "docker commit" command on the container.

The primary use case for Dockershare is for development purposes.  It allows a developer to modify a container's CoW filesystem via host applications and then commit the container to an image.  By committing the state of the container to an image, a developer can effectively make snapshots of any container throughout development, which can later be restored.

## Installation

Pull via DockerHub

	$ docker pull ahnick/dockershare

or alternatively clone this repo and then "docker build" your own version.

## Usage

Run the container using the following command.

	$ docker run -d --name dockershare -p 137:137 -p 138:138 -p 139:139 -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/docker ahnick/dockershare

The key things being done here are:
* Forwarding the ports needed for Samba (-p 137:137 -p 138:138 -p 139:139)
* Exposing the Unix socket for Docker (/var/run/docker.sock:/var/run/docker.sock)
* Exposing the directory containing Docker on the host VM (/var/lib/docker:/docker)

Once the dockershare container is running then you can share another container by running the following command:

	$ docker exec dockershare share <container_name>

Now you should be able to access the container via SMB/CIFS.  (e.g. If using "Docker for Mac" goto Go > Connect to Server and type cifs://0.0.0.0)  You should connect as a guest user and then you should be able to access the "containers" share, which should have any container you have exposed via "docker exec".

## Limitations

This currently only works for the AUFS storage driver.  Other storage driver support is probably rather easy to add by modifying the share.sh script.  Please open an issue or submit a pull request if you need support for other storage drivers.
