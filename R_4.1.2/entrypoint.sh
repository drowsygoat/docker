#!/bin/bash

# If no arguments are provided, start an interactive shell
if [ $# -eq 0 ]; then
    exec /bin/bash
else
    # If the first argument is "rstudio", start RStudio Server
    if [ "$1" == "rstudio" ]; then
        exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0
    else
        # Otherwise, run the provided command
        exec "$@"
    fi
fi