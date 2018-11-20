#!/bin/bash

# Prerequisite
# - [Download and Install `jq`](https://stedolan.github.io/jq/download/) for your environment
# Run `./ecsAuditor` and wait, which will return three files
# 1. all.txt 2. stacked.txt 3. orphaned.txt

# Get the $ENV right
export AWS_DEFAULT_PROFILE='<profile-name>'
export AWS_DEFAULT_REGION='<region-name>'

# List all ECR repos
ALL_ECR_REPOS=$(aws ecr describe-repositories | jq -r '.repositories[].repositoryName')
printf %s\\n $ALL_ECR_REPOS >> all.txt

# List ECR repos under CloudFormation Stacks
STACK_LIST=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE | jq -r '.StackSummaries[].StackName')

for STACK_NAME in $STACK_LIST;
do
  RESOURCE_TYPE=$(aws cloudformation list-stack-resources --stack-name $STACK_NAME | jq -r '.StackResourceSummaries[].ResourceType')
  if [ "$RESOURCE_TYPE" = 'AWS::ECR::Repository' ];
  then
    STACKED_ECR_REPOS=$(aws cloudformation list-stack-resources --stack-name $STACK_NAME | jq -r '.StackResourceSummaries[].PhysicalResourceId')
    echo $STACKED_ECR_REPOS >> stacked.txt
  fi
done

# Find the orphaned repos
sort stacked.txt all.txt | uniq -u >> orphaned.txt