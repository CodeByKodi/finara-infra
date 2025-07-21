# finara-infra

## 🔐 GCP Service Account Setup & GitHub Secrets

### Step 1: Create Service Account

Create a new service account for CI/CD deployments:

```bash
gcloud iam service-accounts create finara-ci-deployer
```

Assign the following roles to the service account:

- Cloud Functions Developer
- Editor
- Firebase Admin
- Project IAM Admin
- Service Account Admin
- Storage Admin
- Vertex AI User

You can do this via the console or with `gcloud`:

```bash
gcloud projects add-iam-policy-binding geni-project \
  --member="serviceAccount:finara-ci-deployer@geni-project.iam.gserviceaccount.com" \
  --role="roles/editor"
# Repeat for other roles...
```

### Step 2: Generate the Service Account Key

```bash
gcloud iam service-accounts keys create ~/gcp-sa-key.json \
  --iam-account=finara-ci-deployer@geni-project.iam.gserviceaccount.com
```

### Step 3: Authenticate Locally (for testing)

```bash
export GOOGLE_APPLICATION_CREDENTIALS=~/Downloads/geni-project-cf46644be753.json
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
gcloud config set project geni-project
gcloud auth list
gcloud projects describe geni-project
```

If you encounter the following error:

> `Cloud Resource Manager API has not been used in project ... or it is disabled`

Follow the link provided in the error or run:

```bash
gcloud services enable cloudresourcemanager.googleapis.com
```

### Step 4: Add GitHub Secret

To store the key securely in GitHub Actions:

1. Encode the key to base64:
   ```bash
   base64 -i ~/Downloads/geni-project-cf46644be753.json | tr -d '\n'
   ```
2. Copy the output and add it as a GitHub Secret:
   - **Name**: `GCP_SA_KEY`
   - **Value**: *(paste the base64 string)*

This secret will be used in the workflow to authenticate with GCP.
