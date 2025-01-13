#!/bin/bash

# Default local and container base paths
LOCAL_BASE_PATH="/cfs/klemming/projects/snic/sllstore2017078/lech"
CONTAINER_BASE_PATH="/mnt"
SANDBOXES_PATH="/cfs/klemming/projects/supr/sllstore2017078/lech/singularity_sandboxes"

# Default Singularity options
SINGULARITY_OPTIONS=""

# Function to display usage information
usage() {
    echo "Usage: $0 [-b] [-B <host_path>] [-c] [-C] <sandbox_name> <command> [options...]"
    echo ""
    echo "Options:"
    echo "  -b  Use custom bind paths for LOCAL_BASE_PATH and CONTAINER_BASE_PATH"
    echo "  -B  Bind additional custom path (the same path in both host and container)"
    echo "  -c  Use the --cleanenv option for Singularity"
    echo "  -C  Use the --contain option for Singularity"
    echo "  -h  Display this help message"
    exit 1
}

# Parse options
USE_CUSTOM_PATHS=false
CUSTOM_BIND_PATH=""
while getopts ":bcCB:hB:" opt; do
    case ${opt} in
        b)
            USE_CUSTOM_PATHS=true
            ;;
        B)
            CUSTOM_BIND_PATH="$OPTARG"
            ;;
        c)
            SINGULARITY_OPTIONS+=" --cleanenv"
            ;;
        C)
            SINGULARITY_OPTIONS+=" --contain"
            ;;
        h)
            usage
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
    esac
done
shift $((OPTIND - 1))

# Check if enough arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Error: Missing arguments."
    usage
fi

# Assign first argument to the sandbox name
SANDBOX_NAME=$1
shift

# The remaining arguments are the command and its options
COMMAND="$@"

# Validate that the sandbox exists
if [ ! -d "${SANDBOXES_PATH}/${SANDBOX_NAME}" ]; then
    echo "Error: Sandbox '${SANDBOX_NAME}' not found in '${SANDBOXES_PATH}'"
    exit 1
fi

# Determine the bind path and working directory
if [ "$USE_CUSTOM_PATHS" = true ]; then
    # If -b is used, bind LOCAL_BASE_PATH to CONTAINER_BASE_PATH
    SINGULARITY_OPTIONS+=" --bind ${LOCAL_BASE_PATH}:${CONTAINER_BASE_PATH}"
    CONTAINER_DIR="${CONTAINER_BASE_PATH}${PWD#$LOCAL_BASE_PATH}"
else
    # Default behavior: bind current working directory
    SINGULARITY_OPTIONS+=" --bind ${PWD}:${PWD}"
    CONTAINER_DIR="${PWD}"
fi

# Add custom bind path if provided (binding the same path in host and container)
if [ -n "$CUSTOM_BIND_PATH" ]; then
    SINGULARITY_OPTIONS+=" --bind ${CUSTOM_BIND_PATH}:${CUSTOM_BIND_PATH}"
fi

# Log the command being run (optional)
echo "Running: singularity exec ${SINGULARITY_OPTIONS} --pwd ${CONTAINER_DIR} ${SANDBOXES_PATH}/${SANDBOX_NAME} ${COMMAND}"

# Run the Singularity command
singularity exec ${SINGULARITY_OPTIONS} --pwd "${CONTAINER_DIR}" "${SANDBOXES_PATH}/${SANDBOX_NAME}" ${COMMAND}
