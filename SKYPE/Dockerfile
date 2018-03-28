FROM python:2.7.10

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -f install --fix-missing
# Configurar multiarch porque Skype solo tiene 32 bits
# Asegúrar de que la información del repositorio esté actualizada
RUN dpkg --add-architecture i386 && \
 apt-get update && apt-get install -y \
 curl \
 --no-install-recommends
 
# Instalar Skype
RUN curl http://download.skype.com/linux/skype-debian_4.3.0.37-1_i386.deb -o /usr/src/skype.deb
RUN dpkg -i /usr/src/skype.deb || true

# Detectar e instalar dependencias automáticamente
RUN apt-get -fy install --fix-missing
RUN rm -rf /var/lib/apt/lists/* # pureg temp data

## Install modulos de Python
RUN apt-get update -y

RUN apt-get install -y python-pip && \
    pip install Skype4Py && \
    pip install jenkinsapi

# Start Skype
ENTRYPOINT ["skype"]
