# Using Docker with Singularity on the Dardel Cluster

This guide provides step-by-step instructions for creating, deploying, and running containers using Docker and Singularity on the Dardel cluster.

---

## 1. Prepare the Container with Docker

### Save Modifications to the Docker Container
If you've modified a running container, save its state as a new image:
```bash
docker commit <container_id_or_name> <repository>:<tag>
```
Example:
```bash
docker commit flamboyant_agnesi drowsygoat/r_archr:1.0.4
```

### Push the Image to Docker Hub
Upload the container image to Docker Hub for easy access from the cluster:
```bash
docker push <repository>:<tag>
```
Example:
```bash
docker push drowsygoat/r_archr:1.0.4
```

### Test or Modify the Image Locally
Before deploying, verify and refine the container by running it locally:
```bash
docker run -it -v $(pwd):/mnt <repository>:<tag>
```
Example:
```bash
docker run -it -v $(pwd):/mnt drowsygoat/r_archr:1.0.3
```

---

## 2. Deploy the Container on the Dardel Cluster

### Pull the Docker Image with Singularity
Load Singularity module if not loaded
```bash
ml singularity
```
Pull the Docker container into a Singularity Image Format (SIF) file:
```bash
singularity pull -F <output_filename>.sif docker://<repository>:<tag>
```
Example:
```bash
singularity pull -F r_archr.sif docker://drowsygoat/r_archr:1.0.4
```

### Run the Container on the Cluster
Use the `sing.sh` script to execute commands inside the container:
```bash
sing.sh -B <bind_path> <sandbox_name> <command> [options...]
```
Example:
```bash
sing.sh -B /cfs/klemming/ r_archr Rscript "$my_script" --dir "$JOB_NAME" --name "$sample_id" --sample "$sample_path" --threads "$cpus" --gtf "$anno"
```

---

## 3. Understanding the `sing.sh` Script

The `sing.sh` script simplifies running containers on the cluster with proper bindings and environment isolation.

### Key Features
- **Default Paths**:
  - **Local Base Path**: `/cfs/klemming/projects/snic/sllstore2017078/lech`
  - **Container Base Path**: `/mnt`
  - **Sandboxes Path**: `/cfs/klemming/projects/supr/sllstore2017078/lech/singularity_sandboxes`

- **Singularity Options**:
  - `-b`: Bind custom paths for local and container base directories.
  - `-B`: Bind additional custom paths (same in host and container).
  - `-c`: Use `--cleanenv` for a clean environment.
  - `-C`: Use `--contain` for container isolation.

### Usage Syntax
```bash
sing.sh [-b] [-B <host_path>] [-c] [-C] <sandbox_name> <command> [options...]
```

### How It Works
1. **Bind Paths**: The script binds directories between the host and the container.
   - By default, it binds the current working directory.
   - With `-b`, it binds `LOCAL_BASE_PATH` to `CONTAINER_BASE_PATH`.
   - With `-B`, it binds additional custom paths.

2. **Environment Options**:
   - `--cleanenv`: Clears the container’s environment, using only the provided variables.
   - `--contain`: Isolates the container from the host system.

3. **Run Command**:
   The container is executed using `singularity exec`:
   ```bash
   singularity exec ${SINGULARITY_OPTIONS} --pwd "${CONTAINER_DIR}" "${SANDBOXES_PATH}/${SANDBOX_NAME}" ${COMMAND}
   ```

### Example
To run an R script within the container:
```bash
sing.sh -B /cfs/klemming/ r_archr Rscript "$my_script" --dir "$JOB_NAME" --name "$sample_id" --sample "$sample_path" --threads "$cpus" --gtf "$anno"
```

---

## 4. Workflow Summary

1. Use Docker to create and test your container.
2. Push the container to Docker Hub for deployment.
3. Pull the container on the Dardel cluster using Singularity.
4. Run the container on the cluster using `sing.sh` script  with appropriate options.
