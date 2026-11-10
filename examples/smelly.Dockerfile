FROM ubuntu
RUN apt-get update
RUN apt-get install -y python3 python3-pip curl
RUN pip3 install flask
ENV DB_PASSWORD=secret123
COPY . /app
RUN cd /app && curl -s https://example.com/setup.sh | bash
CMD python3 /app/app.py
