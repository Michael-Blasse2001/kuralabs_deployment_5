FROM python
RUN  pip install -U pip
WORKDIR /app
ADD ./url-shortner.tar.gz .
RUN pip install -r requirements.txt
EXPOSE 5000
ENTRYPOINT FLASK_APP=application flask run --host=0.0.0.0