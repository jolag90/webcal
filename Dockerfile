ARG MIX_ENV="prod"

# build stage
FROM hexpm/elixir:1.13.0-erlang-24.2-alpine-3.13.6 AS build
# install build dependencies
RUN apk add --no-cache build-base git python3 curl

# sets work dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

# copy compile configuration files
RUN mkdir -p config data/test data/prod 
COPY config/config.exs config/$MIX_ENV.exs config/

# compile dependencies
RUN mix deps.compile

# copy assets
COPY priv priv
COPY assets assets

# Compile assets
RUN mix assets.deploy

# compile project
COPY lib lib
RUN mix compile

# copy runtime configuration file
COPY config/runtime.exs config/

COPY scripts scripts

RUN mix release

# app stage
FROM alpine:3.14.2 AS app

ARG MIX_ENV
ENV MIX_ENV=prod

# install runtime dependencies
RUN apk add --no-cache libstdc++ openssl ncurses-libs

ENV USER="elixir"
ENV USER_ID=1001

WORKDIR "/home/${USER}/app"

# Create  unprivileged user to run the release
RUN \
    addgroup \
    -g "${USER_ID}" \
    -S "${USER}" \
    && adduser \
    -s /bin/sh \
    -u "${USER_ID}" \
    -G "${USER}" \
    -h "/home/${USER}" \
    -D "${USER}" \
    && su "${USER}"

# run as user
USER "${USER}"

# copy release executables
COPY --from=build --chown="${USER}":"${USER}" /app/_build/"${MIX_ENV}"/rel/webcal ./  
# eventuell                                 -r  do eisetzn ...r = recursive
ENTRYPOINT  ["bin/webcal", "start"]

#CMD ["start"]