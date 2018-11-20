# miscBash
Contains multipurpose miscellaneous bash scripts

## 1. `ecrAuditor.sh`
Your AWS environment is fully automated via some kind of infra as a code solution or direct `CloudFormation` template. You want to audit your AWS ECR repos every now and then to check repos created outside the pipeline/infra-automation and advise the developers.

### 1.1 Pre-requisite
- Set up your `AWS` environment using `aws configure` or follow [this](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html)
- [Download and Install `jq`](https://stedolan.github.io/jq/download/) for your environment

### 1.2 How To
Run `./ecrAuditor.sh`. This will create 3 files in `.` directory.
- `all.txt` : contains all repos
- `stacked.txt` : contains all repos create via infras-automation/CloudFormation
- `orphaned.txt` : `diff` between above two, which is the list of manually created ecr

