# MongoDB Backup Tools Image (MongoDB + AWS CLI)

This repository builds a lightweight Docker image that bundles:

- **MongoDB 7.0.16 tools** (`mongodump`, `mongorestore`, etc.)
- **AWS CLI v2**
- A minimal Debian base (from the official `mongo` image)

The image is intended for **Kubernetes CronJobs** or any environment where you need to:

- Dump a MongoDB database
- Upload the backup to S3 (or any S3-compatible storage)
- Run the process reliably in a single container

This avoids installing AWS CLI at runtime and keeps the execution fast and repeatable.

## Features

- Based on the **official MongoDB 7.0.16** image
- Includes **awscli v2**
- Minimal install footprint
- Clean, reproducible build via GitHub Actions
- Publishes automatically to GitHub Container Registry (GHCR)

## Image Location

Once published, the container image is available at: ghcr.io/<your-username-or-org>/mongo-backup-tools:latest


Replace `<your-username-or-org>` with your GitHub namespace.

## Usage Example (Kubernetes CronJob)

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: mongo-backup-hourly
spec:
  schedule: "0 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: backup
              image: ghcr.io/<your-username-or-org>/mongo-backup-tools:latest
              command:
                - /bin/sh
                - -c
                - |
                  TS=$(date +%Y%m%d-%H%M)
                  FILE=/tmp/mongo-$TS.gz

                  mongodump --uri="$MONGO_URI" \
                    --archive=$FILE --gzip

                  aws s3 cp $FILE s3://your-bucket/backups/

              env:
                - name: MONGO_URI
                  valueFrom:
                    secretKeyRef:
                      name: mongo-credentials
                      key: uri
                - name: AWS_ACCESS_KEY_ID
                  valueFrom:
                    secretKeyRef:
                      name: aws-credentials
                      key: AWS_ACCESS_KEY_ID
                - name: AWS_SECRET_ACCESS_KEY
                  valueFrom:
                    secretKeyRef:
                      name: aws-credentials
                      key: AWS_SECRET_ACCESS_KEY
                - name: AWS_DEFAULT_REGION
                  value: "eu-central-1"
```

### Running Locally
``` 
docker run --rm -it ghcr.io/<your-username-or-org>/mongo-backup-tools:latest bash

```


### License
You are free to use, fork, or modify this repository.
MongoDB and AWS CLI are subject to their own respective licenses.
