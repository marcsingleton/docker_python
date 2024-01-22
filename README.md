# Basic Python Scientific Stack Docker Image

## Background
This repository contains a dockerfile for a relatively lean image for computing using the Python scientific stack. I was motivated to build this image to facilitate data-focused computing on cloud environments. In AWS, for example, maintaining a persistent computing environment requires paying to store those resources, which may not be cost-effective when the cloud resources are used infrequently. Moreover, different parts of a project may require different computing needs, meaning a computing environment should easily migrate between different hardware infrastructures, both at the level of computing instances or even the providers of those instances themselves. Installing these components from scratch each time a computing environment is needed is tedious and error-prone, so Docker, which is roughly like a lightweight virtual machine whose specific components are easily customized via dockerfiles, has become an industry-standard solution for providing consistent computing environments in a variety of use cases.

There are already many official Docker images that offer ready-made and optimized computing environments, and scientific computing is no different. The Jupyter development team maintains a set of Docker image definitions specifically for their notebook stack in their [docker-stacks repository](https://github.com/jupyter/docker-stacks). While these are useful for getting started quickly, I found that even their more minimal computing environments are a little bloated. For example, their scipy-notebook image is 3.89 GB at the time of writing and contains many components which are unnecessary for running Python scripts built on the standard scientific stack, for example package managers (conda, mamba) among other utilities.

Thus, in this dockerfile I instead wanted to a create an relatively minimal image that would support my typical workflow on a cloud computing instance, which is mainly configuring and running scripts that were developed on my local machine. It contains the Python base scientific stack (NumPy, SciPy, matplotlib, pandas), Jupyter Lab for notebook-style exploratory analysis, and some core developer and command-line utilities. The included software is certainly idiosyncratic to me, so I encourage anyone to modify the image definition to their needs according to the terms in the attached license.

I used Ubuntu as the base and installed the components using the included package manager APT. There are likely more manual ways of installing and configuring the packages that would yield a leaner image, but I opted for simplicity in the dockerfile. The resulting image at the current time of build is 943 MB, which is a significant improvement over the official Jupyter stacks and sufficiently small for my needs.

## Use
Use the following command to build the image locally:

```
docker build --tag myjupyter .
```

Then run the following to start the container in an interactive session:

```
docker run --interactive --tty --expose 8888:8888 myjupyter
```

Some notes on the options:
- --interactive (-i) keeps the container's `STDIN` open, allowing you to send input to the container through standard input.
- --tty (-t) attaches a pseudo-TTY (teletypewriter) to the container, connecting the terminal to the container's I/O streams. The name of this option has its origins in the early days of computing when the outputs were connected to typewriters rather than screens. For our purposes, it tells the container its output is intended for a terminal interface, which changes how some commands format their outputs.
- --expose (p) binds a port of the container to one of the host using the format `HOST_IP:HOST_PORT:CONTAINER_PORT`. Not specifying an IP address publishes the port to all the host's network interfaces, potentially making them available to the outside world. Port 8888 is the default port for a Jupyter server and is also hardcoded in `jupyter_notebook_config.py`.

The Docker [command-line interface reference](https://docs.docker.com/engine/reference/commandline/docker/) is thorough and contains many examples, so be sure to check it out if you have any questions!
