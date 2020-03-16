FROM arm32v7/python:3-slim-buster as builder

# Dependencies for building the python wheels
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    # Required for pillow
    zlib1g-dev libjpeg-dev libfreetype6-dev \
    # Clear out the cache
    && rm -rf /var/lib/apt/lists/* \
    && apt-get -y autoremove

ADD requirements.txt /requirements.txt
# Builds all python wheels from requirements
RUN pip install -r /requirements.txt


FROM arm32v7/python:3-slim-buster

# Dependencies for running the script itself
RUN apt-get install -y --no-install-recommends \
    # top & free
    procps \
    # A font
    ttf-dejavu \
    # ??
    libopenjp2-7 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get -y autoremove

# Pip wheels compiled in the builder
COPY --from=builder /root/.cache /root/.cache
ADD requirements.txt /requirements.txt

# Python dependencies
RUN pip install -r /requirements.txt \
    && rm -rf ~/.cache/pip

ADD . /pi-oled

CMD python /pi-oled/main.py
