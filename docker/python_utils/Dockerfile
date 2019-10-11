FROM python:3

ADD starmerge.py /
ADD synstore.py /
ADD provenance.py /

COPY starmerge.py /usr/local/bin
COPY synstore.py /usr/local/bin
COPY provenance.py /usr/local/bin
COPY provenance-se.py /usr/local/bin

RUN chmod a+x /usr/local/bin/starmerge.py
RUN chmod a+x /usr/local/bin/synstore.py
RUN chmod a+x /usr/local/bin/provenance.py
RUN chmod a+x /usr/local/bin/provenance-se.py
RUN pip install synapseclient

CMD [ "python" ]
