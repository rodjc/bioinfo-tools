# Bioinformatics Tools Docker Environment

This repository provides a Docker environment pre-configured with essential bioinformatics tools, including [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/), [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml), [BWA](http://bio-bwa.sourceforge.net/), [GATK](https://gatk.broadinstitute.org/hc/en-us), and [Minimap2](https://github.com/lh3/minimap2), among others. It also includes [Nextflow](https://www.nextflow.io/) for workflow management. The environment is based on a Debian image and is designed to simplify the setup and usage of common bioinformatics tools in a containerized format.

## Tools Included
- **Bowtie2**: v2.5.4
- **BWA**: v0.7.18
- **FastQC**: v0.12.1
- **GATK**: v4.6.0.0
- **Minimap2**: v2.28
- **SAMtools**: v1.21
- **BCFtools**: v1.21
- **HTSlib**: v1.21
- **Trimmomatic**: v0.39
- **Java**: v17 (for GATK and other Java-based tools)
- **Nextflow**

## Prerequisites

- Docker and Docker Compose installed on your machine.

## Customizing Tool Versions

You can always set the versions of the tools and the Debian image used in the container by modifying the `docker-compose.yml` file. The `args` section in the `docker-compose.yml` allows you to specify the desired version of each tool and the base Debian image. For example, to change the version of Bowtie2 or the Debian image, simply update the values like this:

```yaml
args:
  DEBIAN_IMAGE: bullseye-slim
  BOWTIE2_VERSION: 2.5.4
  BWA_VERSION: 0.7.18
  # Other tools' versions can be updated here
```
By adjusting these values, you can tailor the environment to your specific requirements.

## Quick Start Guide

To quickly set up the bioinformatics tools environment, follow these steps:

### 1. Clone the Repository

First, clone this repository to your local machine:

```bash
git clone https://github.com/rjc-lab/bioinfo-tools.git
```

### 2. Navigate to the Project Directory

Change to the project directory:

```bash
cd bioinfo-tools
```

### 3. Build and Start the Container

Build the Docker image and start the container using Docker Compose:

```bash
docker compose up -d --build
```

This command will build the Docker image using the `Dockerfile` and configurations provided in the `docker-compose.yml` file.

### 4. Run the Container

To run the bioinformatics tools environment inside the container, execute:

```bash
docker compose run bioinfo-tools
```

This will start the container and allow you to run commands inside the environment pre-configured with bioinformatics tools. If you want to share files with your host machine, you can store them in the shared volumes `input` or `output` created.

### Managing the Container

After you have run the bioinformatics environment, you may need to stop or remove the container. There are two key commands to manage this:

#### 1. Stopping the Container

If you want to **temporarily stop** the container without removing it, you can use:

```bash
docker compose stop
```

This will stop the running container while preserving its current state, networks, and volumes. You can later resume the container with:

```bash
docker compose start
```

This command is useful if you want to pause the environment without losing your progress.

#### 2. Removing the Container

To **completely stop and remove** the container, use:

```bash
docker compose down
```

This command will stop and remove the running container as well as the networks created by Docker Compose. **Important:** If you add the `--volumes` flag, it will also remove the associated volumes, which will lead to the loss of any data not stored in the mounted directories `input` and `output`.

```bash
docker compose down --volumes
```

This is useful when you want to clean up resources or start fresh. However, make sure any important data is stored in the shared `input` and `output` volumes before using this command to avoid accidental data loss.

### Important Warnings

- **File Storage and Volume Mounts**: Ensure that any important files you need from within the container are saved in the shared `input` or `output` volumes. Any data not stored in these mounted directories will be lost when the container is stopped or removed. Files inside the container that are not saved to these shared directories are not persistent.
  
- **Data Loss**: Stopping and removing the container with `docker compose down` only removes the running instance, not the volumes or images. However, if you rebuild the image or delete the volumes, you may lose all data stored inside the container that is not part of the `input` or `output` mounted directories.

By using the shared volumes, you ensure that your data remains safe on the host machine, even if the container is stopped or removed.
