FROM debian:bookworm-slim as base

ARG DEBIAN_FRONTEND noninteractive

# Locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV VIRTUAL_ENV /opt/astronomican_venv
ENV PATH ${VIRTUAL_ENV}/bin:${PATH}
ENV DJANGO_SETTINGS_MODULE astronomican.settings.production

ENV PYTHONDONTWRITEBYTECODE 1

WORKDIR /opt/astronomican

RUN useradd -m --shell /bin/false astronomican

RUN set -eux; \
    { \
      echo "locales locales/default_environment_locale select en_US.UTF-8"; \
      echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8"; \
    } | debconf-set-selections; \
    apt-get update; \
    apt-get -y dist-upgrade; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
    apt-get -y install --no-install-recommends \
      python3 \
      python3-venv \
      python3-pip \
      locales; \
    apt-get clean all; \
    rm -rf /var/lib/apt/*


FROM base as builder

COPY requirements.txt requirements.txt

RUN set -eux; \
    apt-get update; \
    apt-get -y install --no-install-recommends pkg-config build-essential python3-dev default-libmysqlclient-dev; \
    python3 -m venv "${VIRTUAL_ENV}"; \
    pip install -r requirements.txt


FROM builder as production

COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}
COPY . .

USER astronomican

CMD [ "gunicorn", "astronomican.wsgi:application" ]
