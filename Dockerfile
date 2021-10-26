FROM python:3.9
WORKDIR /usr/src/app

ENV LANG=C.UTF-8
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

ENV PATH="/usr/lib/rhasspy/bin:$PATH"

ENV APP_DIR=/usr/lib/rhasspy

RUN apt-get update && \
    apt-get install --no-install-recommends --yes \
    portaudio19-dev swig libpulse-dev && \
    rm -rf /var/lib/apt/lists/*

COPY rhasspy .

RUN python -m venv ${APP_DIR}
RUN pip install --no-cache-dir \
rhasspy-hermes/ \
rhasspy-microphone-pyaudio-hermes/ \
rhasspy-speakers-cli-hermes/ \
rhasspy-profile/ \
rhasspy-server-hermes/ \
rhasspy-supervisor/ \
rhasspy-wake-pocketsphinx-hermes/ \
rhasspy-wake-porcupine-hermes/ \
rhasspy-wake-precise-hermes/ \
rhasspy-wake-raven/ \
rhasspy-wake-snowboy-hermes/ \
supervisor

# there's a weird version mismatch going on with this guy and rhasspy-wake-raven
RUN pip install --no-cache-dir --no-deps rhasspy-wake-raven-hermes/

FROM python:3.9-slim

ENV APP_DIR=/usr/lib/rhasspy
ENV LANG=C.UTF-8
ENV PATH="/usr/lib/rhasspy/bin:$PATH"

RUN apt-get update && \
    apt-get install --no-install-recommends --yes \
    alsa-utils mosquitto libsndfile1 portaudio19-dev && \
    rm -rf /var/lib/apt/lists/*

COPY rhasspy/etc/shflags ${APP_DIR}/etc/
COPY rhasspy/VERSION rhasspy/RHASSPY_DIRS ${APP_DIR}/
COPY rhasspy/bin/rhasspy-voltron rhasspy/bin/voltron-run ${APP_DIR}/bin/

COPY --from=0 ${APP_DIR} ${APP_DIR}
COPY rhasspy/rhasspy-server-hermes/ ${APP_DIR}/rhasspy-server-hermes/
COPY rhasspy/rhasspy-wake-pocketsphinx-hermes/ ${APP_DIR}/rhasspy-wake-pocketsphinx-hermes/
COPY rhasspy/rhasspy-wake-raven/ ${APP_DIR}/rhasspy-wake-raven/
COPY rhasspy/rhasspy-wake-raven-hermes/ ${APP_DIR}/rhasspy-wake-raven-hermes/

EXPOSE 12101
ENTRYPOINT ["bash", "/usr/lib/rhasspy/bin/rhasspy-voltron"]
