#!/bin/bash

for i in {1..100}; do
  echo "$i $(date '+%S.%3N')"
  sleep 0.1
done
