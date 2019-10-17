from django.db import models


class PullReqeusts(models.Model):
    title = models.CharField(max_length=100)
    description = models.TextField()
    user_name = models.CharField(max_length=100)
    pull_request_url = models.URLField()
    gravatar_url = models.URLField()
    account_url = models.URLField()
    state = models.CharField(max_length=50)
    date_created = models.CharField(max_length=100)
    
#! state corresponds to whether the issue or pull request is open or not


class PullRequestTag(models.Model):
    tag = models.CharField(max_length=200)
    pull_requests = models.ManyToManyField(PullReqeusts)


class Issues(models.Model):
    title = models.CharField(max_length=100)
    description = models.TextField()
    user_name = models.CharField(max_length=100)
    gravatar_url = models.URLField()
    issue_url = models.URLField()
    state = models.CharField(max_length=50)
    date_created = models.CharField(max_length=100)


class IssueTag(models.Model):
    tag = models.CharField(max_length=200)
    issues = models.ManyToManyField(Issues)


class GitHubUser(models.Model):
    name = models.CharField(max_length=50)
    token = models.CharField(max_length=100)
    profile_pic_url = models.URLField()
    issues = models.ManyToManyField(Issues, blank=True)
    pulls = models.ManyToManyField(PullReqeusts, blank=True)
