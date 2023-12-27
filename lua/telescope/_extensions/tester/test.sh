#!/bin/bash

for i in {1..500}; do
  echo "$i $(date '+%S.%3N')"
  sleep 0.1
done
