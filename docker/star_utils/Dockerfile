FROM biocontainers/biocontainers:v1.0.0_cv4

MAINTAINER James Eddy <james.a.eddy@gmail.com>

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    tzdata

ENV CONDA_PACKAGES \
  star=2.5.1b \
  r=3.4.1 \
  r-tidyr \
  r-readr \
  r-stringr \
  r-purrr \
  r-dplyr \
  r-argparse

RUN conda install ${CONDA_PACKAGES}

RUN conda install star=2.5.1b

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/combine_counts_study.R

CMD ["/bin/bash"]
