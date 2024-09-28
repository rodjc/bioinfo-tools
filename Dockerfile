ARG DEBIAN_IMAGE=bullseye-slim

FROM debian:${DEBIAN_IMAGE}

# Set environment variables to prevent interaction during installation
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Define build arguments for tool versions
ARG BCFTOOLS_VERSION=1.21
ARG BOWTIE2_VERSION=2.5.4
ARG BWA_VERSION=0.7.18
ARG FASTQC_VERSION=0.12.1
ARG GATK_VERSION=4.6.0.0
ARG HTSLIB_VERSION=1.21
ARG JAVA_VERSION=17
ARG MINIMAP2_VERSION=2.28
ARG SAMTOOLS_VERSION=1.21
ARG TRIMMOMATIC_VERSION=0.39
ARG USER_GID=1000
ARG USER_UID=1000
ARG USERNAME=bioinfo

# Install basic dependencies 
RUN apt update && apt install -y \
    autoconf \
    automake \
    bash \
    build-essential \
    ca-certificates \
    curl \
    openjdk-${JAVA_VERSION}-jre \
    g++ \
    gcc \
    git \
    gzip \
    libbz2-dev \
    libcurl4-gnutls-dev \
    libdeflate-dev \
    libfontconfig1 \
    liblzma-dev \
    libncurses-dev \
    libssl-dev \
    make \
    perl \
    python3 \
    python3-dev \
    python3-pip \
    sudo \
    tar \
    unzip \
    wget \
    zlib1g-dev

# Cleanup installation cache
RUN apt-get clean && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/*

# Install BCFtools
RUN wget https://github.com/samtools/bcftools/releases/download/${BCFTOOLS_VERSION}/bcftools-${BCFTOOLS_VERSION}.tar.bz2 && \
    tar -xvjf bcftools-${BCFTOOLS_VERSION}.tar.bz2 && \
    cd bcftools-${BCFTOOLS_VERSION} && \
    ./configure && \
    make && \
    make install && \
    mv bcftools /usr/local/bin/ && \
    cd .. && \  
    rm -rf bcftools-${BCFTOOLS_VERSION} bcftools-${BCFTOOLS_VERSION}.tar.bz2

# Install Bowtie2
RUN wget https://github.com/BenLangmead/bowtie2/releases/download/v${BOWTIE2_VERSION}/bowtie2-${BOWTIE2_VERSION}-linux-x86_64.zip && \
    unzip bowtie2-${BOWTIE2_VERSION}-linux-x86_64.zip && \
    mv bowtie2-${BOWTIE2_VERSION}-linux-x86_64/* /usr/local/bin/ && \
    rm -rf bowtie2-${BOWTIE2_VERSION}-linux-x86_64.zip bowtie2-${BOWTIE2_VERSION}-linux-x86_64

# Install BWA
RUN git clone https://github.com/lh3/bwa.git && \
    cd bwa && \
    git checkout tags/v${BWA_VERSION} && \
    make && \
    mv bwa /usr/local/bin/ && \
    cd .. && \
    rm -rf bwa

# Install FastQC
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v${FASTQC_VERSION}.zip && \
    unzip fastqc_v${FASTQC_VERSION}.zip && \
    chmod +x FastQC/fastqc && \
    mv FastQC /opt/fastqc && \
    ln -s /opt/fastqc/fastqc /usr/local/bin/fastqc && \
    rm -rf fastqc_v${FASTQC_VERSION}.zip 

# Install GATK
RUN wget https://github.com/broadinstitute/gatk/releases/download/${GATK_VERSION}/gatk-${GATK_VERSION}.zip && \
    unzip gatk-${GATK_VERSION}.zip && \
    mv gatk-${GATK_VERSION} /opt/gatk && \
    ln -s /opt/gatk/gatk /usr/local/bin/gatk && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf gatk-${GATK_VERSION}.zip

# Install HTSlib
RUN wget https://github.com/samtools/htslib/releases/download/${HTSLIB_VERSION}/htslib-${HTSLIB_VERSION}.tar.bz2 && \
    tar -xvjf htslib-${HTSLIB_VERSION}.tar.bz2 && \
    cd htslib-${HTSLIB_VERSION} && \
    ./configure && \
    make && \
    make install && \
    mv htslib /usr/local/bin/ && \
    cd .. && \  
    rm -rf htslib-${HTSLIB_VERSION} htslib-${HTSLIB_VERSION}.tar.bz2

# Install Minimap2
RUN git clone https://github.com/lh3/minimap2.git && \
    cd minimap2 && \
    git checkout tags/v${MINIMAP2_VERSION} && \
    make && \
    mv minimap2 /usr/local/bin/ && \
    cd .. && \
    rm -rf minimap2

# Install Nextflow
RUN curl -s https://get.nextflow.io | bash && \
    chmod +x nextflow && \
    mv nextflow /usr/local/bin

# Install SAMtools
RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    tar -xvjf samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd samtools-${SAMTOOLS_VERSION} && \
    ./configure && \
    make && \
    make install && \
    mv samtools /usr/local/bin/ && \
    cd .. && \  
    rm -rf samtools-${SAMTOOLS_VERSION} samtools-${SAMTOOLS_VERSION}.tar.bz2

# Install Trimmomatic
RUN wget https://github.com/usadellab/Trimmomatic/files/5854859/Trimmomatic-${TRIMMOMATIC_VERSION}.zip && \
    unzip Trimmomatic-${TRIMMOMATIC_VERSION}.zip && \
    mv Trimmomatic-${TRIMMOMATIC_VERSION} /opt/trimmomatic && \
    ln -s /opt/trimmomatic/trimmomatic-${TRIMMOMATIC_VERSION}.jar /usr/local/bin/trimmomatic.jar && \
    rm -rf Trimmomatic-${TRIMMOMATIC_VERSION}.zip

# Create a new user and grant sudo privileges
RUN groupadd -g $USER_GID $USERNAME && \
    useradd -u $USER_UID -g $USER_GID -m -s /bin/bash $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

CMD ["bash"]
