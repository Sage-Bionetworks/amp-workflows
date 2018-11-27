FROM quay.io/biocontainers/picard:2.18.15--0

MAINTAINER James Eddy <james.a.eddy@gmail.com>

USER root

ENV PACKAGES python-dev python-setuptools python-pip

RUN apt-get update && \
    apt-get install -y --no-install-recommends ${PACKAGES}

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/combine_metrics_sample.py
RUN chmod a+x /usr/local/bin/combine_metrics_study.py
RUN chmod a+x /usr/local/bin/make_refflat.sh
RUN chmod a+x /usr/local/bin/make_riboints.sh

CMD ["/bin/bash"]
