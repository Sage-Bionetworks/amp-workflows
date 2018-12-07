FROM biocontainers/biocontainers:v1.0.0_cv4

MAINTAINER James Eddy <james.a.eddy@gmail.com>

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    tzdata

RUN wget https://github.com/broadinstitute/picard/releases/download/2.2.4/picard-tools-2.2.4.zip && \
  unzip -q picard-tools-2.2.4.zip && \
  rm picard-tools-2.2.4.zip && \
  mv picard-tools-2.2.4 /usr/local/lib/

ENV JAR_DIR /usr/local/lib/picard-tools-2.2.4

ENV CONDA_PACKAGES \
  python=2.7 \
  ucsc-gtftogenepred \
  samtools \
  r=3.4.1 \
  r-tidyr \
  r-readr \
  r-stringr \
  r-purrr \
  r-dplyr \
  r-argparse

RUN conda install ${CONDA_PACKAGES}

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/combine_metrics_sample.py
RUN chmod a+x /usr/local/bin/combine_metrics_study.R
RUN chmod a+x /usr/local/bin/make_refflat.sh
RUN chmod a+x /usr/local/bin/make_riboints.sh
RUN chmod a+x /usr/local/bin/picard.sh

CMD ["/bin/bash"]
