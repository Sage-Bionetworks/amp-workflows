FROM python:3.6

ADD starmerge.py /
ADD synstore.py /
ADD provenance.py /
ADD clean_tables.py /

COPY starmerge.py /usr/local/bin
COPY synstore.py /usr/local/bin
COPY provenance.py /usr/local/bin
COPY provenance-se.py /usr/local/bin
COPY clean_tables.py /usr/local/bin

RUN chmod a+x /usr/local/bin/starmerge.py
RUN chmod a+x /usr/local/bin/synstore.py
RUN chmod a+x /usr/local/bin/provenance.py
RUN chmod a+x /usr/local/bin/provenance-se.py
RUN chmod a+x /usr/local/bin/clean_tables.py

RUN pip install pandas synapseclient

CMD [ "python" ]
