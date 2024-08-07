#!/bin/bash

# If no arguments are provided, start an interactive shell
if [ $# -eq 0 ]; then
    exec /bin/bash
else
    # Otherwise, run the provided command
    exec "$@"
fi

