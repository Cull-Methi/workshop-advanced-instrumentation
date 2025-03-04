#!/bin/bash

go_name() {
  cd go-name || exit

  go build -o bin/go-name main.go

  if [[ -n "$2" ]] && [[ "$2" == "-b" ]]; then
    bin/go-name &
  else
    bin/go-name
  fi
}

go_year() {
  cd go-year || exit

  go build -o bin/go-year main.go

  if [[ -n "$2" ]] && [[ "$2" == "-b" ]]; then
    bin/go-year &
  else
    bin/go-year
  fi
}

java_year() {

  cd java-year || exit

  gradle bootJar

  export OTEL_METRICS_EXPORTER="none"
  export OTEL_EXPORTER_OTLP_ENDPOINT="https://api.honeycomb.io"
  export OTEL_EXPORTER_OTLP_HEADERS="x-honeycomb-team=${HONEYCOMB_API_KEY},x-honeycomb-dataset=${HONEYCOMB_DATASET:-workshop}"
  export OTEL_SERVICE_NAME="java-year"

  if [[ -n "$2" ]] && [[ "$2" == "-b" ]]; then
    java -javaagent:../../lib/opentelemetry-javaagent.jar -jar build/libs/java-year.jar &
  else
    java -javaagent:../../lib/opentelemetry-javaagent.jar -jar build/libs/java-year.jar
  fi
}

node_year() {
  cd node-year || exit

  npm install

  if [[ -n "$2" ]] && [[ "$2" == "-b" ]]; then
    node -r ./tracing.js node-year.js &
  else
    node -r ./tracing.js node-year.js
  fi
}

case $1 in

"go-name")
  echo "go-name"
  go_name "$@"
  ;;

"go-year")
  echo "go-year"
  go_year "$@"
  ;;

"java-year")
  echo "java-year"
  java_year "$@"
  ;;

"node-year")
  echo "node-year"
  node_year "$@"
  ;;
  
*)
  echo "bad option"
  ;;
esac