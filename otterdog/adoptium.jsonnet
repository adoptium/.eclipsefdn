local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

orgs.newOrg('adoptium') {
  settings+: {
    blog: "https://adoptium.net",
    default_repository_permission: "none",
    default_workflow_permissions: "write",
    description: "The Adoptium Working Group promotes and supports high-quality runtimes and associated technology for use across the Java ecosystem",
    name: "Eclipse Adoptium",
    readers_can_create_discussions: true,
    security_managers+: [
      "adoptium-project-leads",
      "adoptium-aqavit-project-leads",
      "adoptium-temurin-project-leads"
    ],
    twitter_username: "adoptium",
    web_commit_signoff_required: false,
  },
  webhooks+: [
    orgs.newOrgWebhook('https://app.codacy.com/2.0/events/gh/organization') {
      content_type: "json",
      events+: [
        "meta",
        "organization",
        "repository"
      ],
      secret: "********",
    },
  ],
  secrets+: [
    orgs.newOrgSecret('ADOPTIUM_AQAVIT_BOT_TOKEN') {
      value: "pass:bots/adoptium.aqavit/github.com/project-token",
    },
    orgs.newOrgSecret('ADOPTIUM_BOT_TOKEN') {
      value: "pass:bots/adoptium/github.com/project-token",
    },
    orgs.newOrgSecret('ADOPTIUM_TEMURIN_BOT_TOKEN') {
      value: "pass:bots/adoptium.temurin/github.com/project-token",
    },
    orgs.newOrgSecret('SLACK_WEBHOOK_CODEFREEZE_URL') {
      value: "pass:bots/adoptium/github.com/slack-webhook-codefreeze-url",
    },
  ],
  _repositories+:: [
    orgs.newRepo('.github') {
      allow_auto_merge: true,
      allow_merge_commit: false,
      allow_update_branch: false,
      dependabot_alerts_enabled: false,
      web_commit_signoff_required: false,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main'),
      ],
    },
    orgs.newRepo('Incubator') {
      allow_update_branch: false,
      dependabot_alerts_enabled: false,
      description: "Adoptium Incubator project",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('STF') {
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      description: "The System Test Framework for executing https://github.com/adoptium/aqa-systemtest",
      homepage: "",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('TKG') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_security_updates_enabled: true,
      description: "TestKitGen (TKG)",
      homepage: "",
      web_commit_signoff_required: false,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
      ],
    },
    orgs.newRepo('aarch32-jdk8u') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_alerts_enabled: false,
      description: "JDK8u mirror (aarch32 port). This source code is an unmodified mirror of source code obtained from OpenJDK https://github.com/openjdk/aarch32-port-jdk8u. It has been and may still be used to create builds that are untested and incompatible with the Java SE specification. You should not deploy or write to this code, but instead use the tested and certified Java SE compatible version of the code that is available at https://adoptium.net.",
      homepage: "",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('aarch32-jdk8u_hg') {
      archived: true,
      default_branch: "master",
      description: "Mirror of the Mercurial Forest for the Linux Aarch32 port from",
      homepage: "https://hg.openjdk.java.net/aarch32-port/jdk8u",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('adoptium') {
      allow_update_branch: false,
      dependabot_alerts_enabled: false,
      has_discussions: true,
      homepage: "https://adoptium.net",
      topics+: [
        "adoptium",
        "aqavit",
        "eclipse",
        "java",
        "temurin"
      ],
      web_commit_signoff_required: false,
    },
    orgs.newRepo('adoptium-support') {
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      description: "For end-user problems reported with our binary distributions",
      has_discussions: true,
      web_commit_signoff_required: false,
    },
    orgs.newRepo('adoptium.net') {
      allow_auto_merge: true,
      allow_merge_commit: false,
      allow_update_branch: false,
      delete_branch_on_merge: true,
      dependabot_security_updates_enabled: true,
      description: "Adoptium Website",
      homepage: "https://adoptium.net",
      topics+: [
        "hacktoberfest"
      ],
      web_commit_signoff_required: false,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: 1,
          required_status_checks+: [
            "Lint Code Base",
            "Run CI",
            "netlify:netlify/eclipsefdn-adoptium/deploy-preview"
          ],
        },
      ],
    },
    orgs.newRepo('alpine-jdk8u') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_security_updates_enabled: true,
      description: "JDK8u mirror. This source code is an unmodified mirror of source code obtained from OpenJDK https://github.com/openjdk/jdk8u. It has been and may still be used to create builds that are untested and incompatible with the Java SE specification. You should not deploy or write to this code, but instead use the tested and certified Java SE compatible",
      homepage: "",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('api.adoptium.net') {
      allow_update_branch: false,
      dependabot_alerts_enabled: false,
      description: "Adoptium API 🚀",
      homepage: "https://api.adoptium.net",
      topics+: [
        "adoptium",
        "api",
        "hacktoberfest",
        "java",
        "openjdk",
        "restful-api",
        "swagger",
        "temurin"
      ],
      web_commit_signoff_required: false,
      secrets: [
        orgs.newRepoSecret('AZURE_CLIENT_ID') {
          value: "bots/adoptium/azure/azure-client-id",
        },
        orgs.newRepoSecret('AZURE_CLIENT_ID_OIDC') {
          value: "bots/adoptium/azure/azure-client-id-oidc",
        },
        orgs.newRepoSecret('AZURE_CLIENT_SECRET') {
          value: "bots/adoptium/azure/azure-client-secret",
        },
        orgs.newRepoSecret('AZURE_SUBSCRIPTION_ID') {
          value: "bots/adoptium/azure/azure-subscription-id",
        },
        orgs.newRepoSecret('AZURE_TENANT_ID') {
          value: "bots/adoptium/azure/azure-tenant-id",
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('marketplace') {
          required_approving_review_count: 1,
          required_status_checks+: [
            "build"
          ],
        },
        orgs.newBranchProtectionRule('marketplace-production') {
          required_approving_review_count: 1,
          required_status_checks+: [
            "build"
          ],
        },
        orgs.newBranchProtectionRule('production') {
          required_approving_review_count: 1,
          required_status_checks+: [
            "Build (adoptium)",
            "Build (adoptopenjdk)"
          ],
        },
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: 1,
          required_status_checks+: [
            "Build (adoptium)",
            "Build (adoptopenjdk)"
          ],
        },
      ],
    },
    orgs.newRepo('aqa-systemtest') {
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      description: "Java load testing and other full system application tests",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('aqa-test-tools') {
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      dependabot_security_updates_enabled: true,
      description: "Home of Test Results Summary Service (TRSS) and PerfNext.  These tools are designed to improve our ability to monitor and triage tests at the Adoptium project.  The code is generic enough that it is extensible for use by any project that needs to monitor multiple CI servers and aggregate their results.",
      homepage: "",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('aqa-tests') {
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      dependabot_security_updates_enabled: true,
      description: "Home of test infrastructure for Adoptium builds",
      homepage: "https://adoptium.net/aqavit",
      topics+: [
        "hacktoberfest",
        "openjdk-tests",
        "tests"
      ],
      web_commit_signoff_required: false,
      webhooks: [
        orgs.newRepoWebhook('https://ci.adoptium.net/ghprbhook/') {
          events+: [
            "issue_comment",
            "pull_request"
          ],
          secret: "pass:bots/adoptium/github.com/ci-webhook-secret",
        },
      ],
      secrets: [
        orgs.newRepoSecret('JENKINS_WORKFLOW_SECRET') {
          value: "********",
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
        orgs.newBranchProtectionRule('*-release') {
          required_approving_review_count: 1,
        },
      ],
    },
    orgs.newRepo('blog.adoptium.net') {
      archived: true,
      description: "The official Adoptium Blog",
      homepage: "https://blog.adoptium.net",
      topics+: [
        "adoptium",
        "blog",
        "eclipse",
        "gatsby",
        "openjdk"
      ],
      web_commit_signoff_required: false,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: 1,
          required_status_checks+: [
            "Check on macos-latest",
            "Check on ubuntu-latest",
            "Check on windows-latest",
            "netlify:netlify/eclipsefdn-adoptium-blog/deploy-preview"
          ],
        },
      ],
    },
    orgs.newRepo('build-jdk') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_security_updates_enabled: true,
      description: "Github action for building JDKs that utilizes the build scripts from the openjdk-build repo",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('bumblebench') {
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      dependabot_security_updates_enabled: true,
      description: "A microbenchmarking test framework for Eclipse Adoptium",
      homepage: "",
      topics+: [
        "benchmark",
        "java",
        "performance"
      ],
      web_commit_signoff_required: false,
    },
    orgs.newRepo('ci-jenkins-pipelines') {
      allow_auto_merge: true,
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      dependabot_alerts_enabled: false,
      description: "jenkins pipeline build scripts",
      homepage: "",
      topics+: [
        "hacktoberfest",
        "jenkins",
        "pipeline"
      ],
      web_commit_signoff_required: false,
      webhooks: [
        orgs.newRepoWebhook('https://ci.adoptium.net/github-webhook/') {
          active: false,
          events+: [
            "commit_comment",
            "issue_comment",
            "issues",
            "label",
            "pull_request",
            "pull_request_review",
            "pull_request_review_comment",
            "push"
          ],
        },
        orgs.newRepoWebhook('https://ci.adoptium.net/ghprbhook/') {
          events+: [
            "issue_comment",
            "pull_request"
          ],
          secret: "pass:bots/adoptium/github.com/ci-webhook-secret",
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
      ],
    },
    orgs.newRepo('containers') {
      allow_auto_merge: true,
      allow_merge_commit: false,
      allow_update_branch: false,
      delete_branch_on_merge: true,
      dependabot_alerts_enabled: false,
      description: "Repo containing the dockerfiles and scripts to produce the official eclipse-temurin containers.",
      has_wiki: false,
      homepage: "https://hub.docker.com/_/eclipse-temurin/",
      topics+: [
        "containers",
        "docker",
        "dockerfile",
        "dockerfiles",
        "dockerhub",
        "hacktoberfest"
      ],
      web_commit_signoff_required: false,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_status_checks+: [
            "conclusion"
          ],
        },
      ],
    },
    orgs.newRepo('dash.adoptium.net') {
      allow_merge_commit: false,
      allow_update_branch: false,
      dependabot_alerts_enabled: false,
      description: "Download tracking dashboard",
      homepage: "https://dash.adoptium.net/",
      topics+: [
        "adoptium",
        "dashboard",
        "eclipse",
        "openjdk",
        "react"
      ],
      web_commit_signoff_required: false,
    },
    orgs.newRepo('documentation') {
      archived: true,
      description: "The new documentation for adoptium.net will be initially created in this repo",
      homepage: "",
      topics+: [
        "documentation",
        "hacktoberfest"
      ],
      web_commit_signoff_required: false,
      webhooks: [
        orgs.newRepoWebhook('https://app.codacy.com/events/github/3b0e019a32bb4307a776e60cff5b031c') {
          content_type: "json",
          events+: [
            "pull_request",
            "push"
          ],
        },
      ],
    },
    orgs.newRepo('documentation-services') {
      archived: true,
      web_commit_signoff_required: false,
      webhooks: [
        orgs.newRepoWebhook('https://app.codacy.com/events/github/695d0c3446bd42d58c11a7ee026d9196') {
          content_type: "json",
          events+: [
            "pull_request",
            "push"
          ],
        },
      ],
    },
    orgs.newRepo('emt4j') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_alerts_enabled: false,
      description: "Eclipse Migration Toolkit for Java",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('github-release-scripts') {
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      dependabot_security_updates_enabled: true,
      description: "Scripts for release artefacts to GitHub releases",
      homepage: "",
      topics+: [
        "github"
      ],
      web_commit_signoff_required: false,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
      ],
    },
    orgs.newRepo('infrastructure') {
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      dependabot_security_updates_enabled: true,
      description: "This repo contains all information about machine maintenance.",
      homepage: "",
      topics+: [
        "ansible",
        "backup",
        "hacktoberfest",
        "infrastructure",
        "infrastructure-systems",
        "nagios"
      ],
      web_commit_signoff_required: false,
      webhooks: [
        orgs.newRepoWebhook('https://ci.adoptium.net/github-webhook/') {
          events+: [
            "push"
          ],
        },
      ],
      secrets: [
        orgs.newRepoSecret('DOCKER_PASSWORD') {
          value: "bots/adoptium/docker.com/password",
        },
        orgs.newRepoSecret('DOCKER_USERNAME') {
          value: "bots/adoptium/docker.com/username",
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
      ],
    },
    orgs.newRepo('installer') {
      allow_auto_merge: true,
      default_branch: "master",
      delete_branch_on_merge: true,
      dependabot_security_updates_enabled: true,
      description: "Installer scripts for Eclipse Temurin binaries",
      homepage: "",
      squash_merge_commit_title: "PR_TITLE",
      topics+: [
        "hacktoberfest",
        "installer"
      ],
      web_commit_signoff_required: false,
      secrets: [
        orgs.newRepoSecret('ARTIFACTORY_PASSWORD') {
          value: "bots/adoptium/artifactory/password",
        },
        orgs.newRepoSecret('ARTIFACTORY_USER') {
          value: "bots/adoptium/artifactory/username",
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
      ],
    },
    orgs.newRepo('jdk') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_alerts_enabled: false,
      description: "JDK mirror from https://github.com/openjdk/jdk",
      homepage: "",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('jdk11u') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_alerts_enabled: false,
      description: "JDK11u mirror. This source code is an unmodified mirror of source code obtained from OpenJDK https://github.com/openjdk/jdk11u. It has been and may still be used to create builds that are untested and incompatible with the Java SE specification. You should not deploy or write to this code, but instead use the tested and certified Java SE compatible version of the code that is available at https://adoptium.net.",
      homepage: "",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('jdk11u-fast-startup-incubator') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_alerts_enabled: false,
      web_commit_signoff_required: false,
    },
    orgs.newRepo('jdk16u') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_alerts_enabled: false,
      description: "JDK16u mirror. This source code is an unmodified mirror of source code obtained from OpenJDK https://github.com/openjdk/jdk16u. It has been and may still be used to create builds that are untested and incompatible with the Java SE specification. You should not deploy or write to this code, but instead use the tested and certified Java SE compatible version of the code that is available at https://adoptium.net.",
      homepage: "",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('jdk17') {
      archived: true,
      default_branch: "master",
      description: "JDK17 mirror. This source code is an unmodified mirror of source code obtained from OpenJDK https://github.com/openjdk/jdk17. It has been and may still be used to create builds that are untested and incompatible with the Java SE specification. You should not deploy or write to this code, but instead, use the tested and certified Java SE compatible version of the code that is available at https://www.adoptium.net.",
      homepage: "",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('jdk17u') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_alerts_enabled: false,
      description: "JDK17u mirror. This source code is an unmodified mirror of source code obtained from OpenJDK https://github.com/openjdk/jdk17u. It has been and may still be used to create builds that are untested and incompatible with the Java SE specification. You should not deploy or write to this code, but instead use the tested and certified Java SE compatible version of the code that is available at https://adoptium.net.",
      homepage: "",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('jdk18') {
      archived: true,
      default_branch: "master",
      description: "JDK18 mirror. This source code is an unmodified mirror of source code obtained from OpenJDK https://github.com/openjdk/jdk18. It has been and may still be used to create builds that are untested and incompatible with the Java SE specification. You should not deploy or write to this code, but instead use the tested and certified Java SE compatible version of the code that is available at https://adoptium.net.",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('jdk18u') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_alerts_enabled: false,
      description: "JDK18u mirror. This source code is an unmodified mirror of source code obtained from OpenJDK https://github.com/openjdk/jdk18u. It has been and may still be used to create builds that are untested and incompatible with the Java SE specification. You should not deploy or write to this code, but instead use the tested and certified Java SE compatible version of the code that is available at https://adoptium.net.",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('jdk19') {
      archived: true,
      default_branch: "master",
      description: "jdk19 repository",
      secret_scanning: "disabled",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('jdk19u') {
      allow_update_branch: false,
      default_branch: "dev",
      dependabot_security_updates_enabled: true,
      secret_scanning: "disabled",
      secret_scanning_push_protection: "disabled",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('jdk20') {
      archived: true,
      default_branch: "master",
      secret_scanning: "disabled",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('jdk20u') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_security_updates_enabled: true,
      secret_scanning: "disabled",
      secret_scanning_push_protection: "disabled",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('jdk21') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_security_updates_enabled: true,
      secret_scanning_push_protection: "disabled",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('jdk8u') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_alerts_enabled: false,
      description: "JDK8u mirror. This source code is an unmodified mirror of source code obtained from OpenJDK https://github.com/openjdk/jdk8u. It has been and may still be used to create builds that are untested and incompatible with the Java SE specification. You should not deploy or write to this code, but instead use the tested and certified Java SE compatible version of the code that is available at https://adoptium.net.",
      homepage: "",
      secret_scanning: "disabled",
      secret_scanning_push_protection: "disabled",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('jdk8u_hg') {
      archived: true,
      default_branch: "master",
      description: "JDK8u mirror from mercurial from",
      homepage: "http://hg.openjdk.java.net/jdk8u/jdk8u/",
      web_commit_signoff_required: false,
    },
    orgs.newRepo('jenkins-helper') {
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      description: "Jenkins Node helper API and helper jobs ",
      homepage: "",
      topics+: [
        "adoptium",
        "groovy",
        "jenkins",
        "jenkins-helper"
      ],
      web_commit_signoff_required: false,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
      ],
    },
    orgs.newRepo('jmc-build') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_security_updates_enabled: true,
      description: "Contains the Adoptium specific source code overrides and build pipeline script for the Java Mission Control project.",
      has_wiki: false,
      homepage: "",
      topics+: [
        "hacktoberfest"
      ],
      web_commit_signoff_required: false,
      secrets: [
        orgs.newRepoSecret('ARTIFACTORY_PASSWORD') {
          value: "bots/adoptium/artifactory/password",
        },
        orgs.newRepoSecret('ARTIFACTORY_USER') {
          value: "bots/adoptium/artifactory/username",
        },
      ],
    },
    orgs.newRepo('marketplace-data') {
      allow_auto_merge: true,
      allow_update_branch: false,
      delete_branch_on_merge: true,
      dependabot_security_updates_enabled: true,
      description: "The official source of Marketplace data (JSON) for feeding Eclipse Temurin binaries to the Marketplace API 💾",
      has_issues: false,
      homepage: "https://marketplace-api.adoptium.net/",
      web_commit_signoff_required: false,
      secrets: [
        orgs.newRepoSecret('TEMURIN_RSA_PRIVATE') {
          value: "bots/adoptium/github.com/temurin-rsa-private",
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: null,
          required_status_checks+: [
            "call-adoptium-verifier / validate"
          ],
          requires_pull_request: false,
        },
      ],
    },
    orgs.newRepo('mirror-scripts') {
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      dependabot_alerts_enabled: false,
      description: "OpenJDK source mirroring scripts used by",
      homepage: "https://ci.adoptium.net/view/git-mirrors/job/git-mirrors/job/adoptium/",
      web_commit_signoff_required: false,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
      ],
    },
    orgs.newRepo('obsolete---adoptium.net') {
      archived: true,
      description: "Development of the website has moved to https://github.com/adoptium/website-v2",
      homepage: "https://github.com/adoptium/website-v2",
      web_commit_signoff_required: false,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: null,
          requires_pull_request: false,
        },
      ],
    },
    orgs.newRepo('run-aqa') {
      allow_update_branch: false,
      default_branch: "master",
      dependabot_security_updates_enabled: true,
      description: "Repository for the Github Action that enables the running of the Adoptium Quality Assurance (AQA) tests",
      homepage: "",
      topics+: [
        "adoptopenjdk",
        "aqa-tests"
      ],
      web_commit_signoff_required: false,
    },
    orgs.newRepo('temurin-build') {
      allow_auto_merge: true,
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      dependabot_security_updates_enabled: true,
      description: "Eclipse Temurin™ build scripts - common across all releases/versions",
      homepage: "",
      topics+: [
        "cacert",
        "docker-commands",
        "docker-container",
        "docker-group",
        "hacktoberfest",
        "shell-script",
        "temurin"
      ],
      web_commit_signoff_required: false,
      webhooks: [
        orgs.newRepoWebhook('https://api.codacy.com/events/github/c7be1d760de3418f836fcfefa494c486') {
          content_type: "json",
          events+: [
            "pull_request",
            "push"
          ],
        },
        orgs.newRepoWebhook('https://ci.adoptium.net/github-webhook/') {
          events+: [
            "commit_comment",
            "issue_comment",
            "issues",
            "label",
            "pull_request",
            "pull_request_review",
            "pull_request_review_comment",
            "push"
          ],
        },
        orgs.newRepoWebhook('https://ci.adoptium.net/ghprbhook/') {
          events+: [
            "issue_comment",
            "pull_request"
          ],
          secret: "pass:bots/adoptium/github.com/ci-webhook-secret",
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
      ],
    },
    orgs.newRepo('temurin11-binaries') {
      allow_update_branch: false,
      description: "Temurin 11 binaries",
      has_issues: false,
      web_commit_signoff_required: false,
    },
    orgs.newRepo('temurin16-binaries') {
      allow_update_branch: false,
      description: "Temurin 16 binaries",
      has_issues: false,
      web_commit_signoff_required: false,
    },
    orgs.newRepo('temurin17-binaries') {
      allow_update_branch: false,
      description: "Temurin 17 binaries",
      has_issues: false,
      web_commit_signoff_required: false,
    },
    orgs.newRepo('temurin18-binaries') {
      allow_update_branch: false,
      description: "Temurin 18 binaries",
      has_issues: false,
      web_commit_signoff_required: false,
    },
    orgs.newRepo('temurin19-binaries') {
      allow_update_branch: false,
      description: "Temurin 19 binaries",
      has_issues: false,
      web_commit_signoff_required: false,
    },
    orgs.newRepo('temurin20-binaries') {
      allow_update_branch: false,
      dependabot_security_updates_enabled: true,
      description: "Temurin 20 binaries",
      has_issues: false,
      web_commit_signoff_required: false,
    },
    orgs.newRepo('temurin21-binaries') {
      allow_update_branch: false,
      dependabot_security_updates_enabled: true,
      description: "Temurin 21 binaries",
      has_issues: false,
      web_commit_signoff_required: false,
    },
    orgs.newRepo('temurin22-binaries') {
      allow_update_branch: false,
      dependabot_security_updates_enabled: true,
      description: "Temurin 22 binaries",
      has_issues: false,
      web_commit_signoff_required: false,
    },
    orgs.newRepo('temurin8-binaries') {
      allow_update_branch: false,
      description: "Temurin 8 binaries",
      has_issues: false,
      web_commit_signoff_required: false,
    },
  ],
}
