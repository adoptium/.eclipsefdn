local orgsOrig = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

// Set Adoptium specific defaults here
local newAdoptiumRepo(name) = orgsOrig.newRepo(name) {
  dependabot_security_updates_enabled: true,
  private_vulnerability_reporting_enabled: true,
  web_commit_signoff_required: false,
};

local orgs = (import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet') + {
  newRepo::newAdoptiumRepo
};

local newMirrorRepo(repoName) = orgs.newRepo(repoName) {
  allow_merge_commit: true,
  allow_update_branch: false,
  auto_init: false,
  default_branch: "master",
  delete_branch_on_merge: false,
  dependabot_alerts_enabled: false,
  dependabot_security_updates_enabled: false,
  has_issues: false,
  has_projects: false,
  has_wiki: false,
  homepage: "https://adoptium.net",
  secret_scanning: "disabled",
  secret_scanning_push_protection: "disabled",
  description: "This repo is an unmodified mirror of source code obtained from OpenJDK. It has been and may still be used to create builds that are untested and incompatible with the Java SE specification. You should not deploy or write to this code, but instead use the tested and certified Java SE compatible version that is available at https://adoptium.net.",
  workflows+: {
    enabled: false,
  },
};

local extractVersion(name) =
  local prefix = "temurin";
  local suffix = "-binaries";
  local versionStart = std.length(prefix);
  local versionEnd = std.length(name) - std.length(suffix);
  if std.startsWith(name, prefix) && std.endsWith(name, suffix) then
    std.substr(name, versionStart, versionEnd - versionStart)
  else
    "unknown";

local newBinaryRepo(repoName) = orgs.newRepo(repoName) {
  description: "Temurin %s binaries" % [extractVersion(repoName)],
  dependabot_alerts_enabled: false,
  dependabot_security_updates_enabled: false,
  has_issues: false,
  has_projects: false,
  has_wiki: false,
  homepage: "https://adoptium.net",
};

orgs.newOrg('adoptium') {
  settings+: {
    blog: "https://adoptium.net",
    description: "The Adoptium Working Group promotes and supports high-quality runtimes and associated technology for use across the Java ecosystem",
    name: "Eclipse Adoptium",
    security_managers+: [
      "adoptium-aqavit-project-leads",
      "adoptium-project-leads",
      "adoptium-temurin-project-leads"
    ],
    twitter_username: "adoptium",
    web_commit_signoff_required: false,
  },
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
    orgs.extendRepo('.eclipsefdn') {
      private_vulnerability_reporting_enabled: true,
    },
    orgs.newRepo('.github') {
      allow_auto_merge: true,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main'),
      ],
    },
    orgs.newRepo('Incubator') {
      allow_merge_commit: true,
      description: "Adoptium Incubator project",
    },
    orgs.newRepo('STF') {
      allow_update_branch: false,
      default_branch: "master",
      delete_branch_on_merge: false,
      description: "The System Test Framework for executing https://github.com/adoptium/aqa-systemtest",
    },
    orgs.newRepo('TKG') {
      allow_merge_commit: true,
      allow_update_branch: false,
      default_branch: "master",
      delete_branch_on_merge: false,
      description: "TestKitGen (TKG)",
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
      ],
    },
    orgs.newRepo('adoptium') {
      allow_merge_commit: true,
      allow_update_branch: false,
      delete_branch_on_merge: false,
      has_discussions: true,
      homepage: "https://adoptium.net",
      topics+: [
        "adoptium",
        "aqavit",
        "eclipse",
        "java",
        "temurin"
      ],
    },
    orgs.newRepo('adoptium-support') {
      description: "For end-user problems reported with our binary distributions",
      has_discussions: true,
    },
    orgs.newRepo('adoptium.net') {
      allow_auto_merge: true,
      description: "Adoptium Website",
      homepage: "https://adoptium.net",
      topics+: [
        "hacktoberfest"
      ],
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
      secrets: [
        orgs.newRepoSecret('CODECOV_TOKEN') {
          value: "pass:bots/adoptium/codecov/adoptium-net-token",
        },
      ],
    },
    orgs.newRepo('adoptium.net-redesign') {
      allow_auto_merge: true,
      description: "Adoptium Website",
      homepage: "https://adoptium-rewrite.netlify.app/",
      topics+: [
        "hacktoberfest"
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: 1,
           required_status_checks+: [
             "Lint Code Base",
             "Run CI",
             "netlify:netlify/adoptium-rewrite/deploy-preview"
           ],
        },
      ],
      secrets: [
        orgs.newRepoSecret('CODECOV_TOKEN') {
          value: "pass:bots/adoptium/codecov/adoptium-redesign-token",
        },
      ],
    },
    orgs.newRepo('api.adoptium.net') {
      allow_merge_commit: true,
      allow_squash_merge: false,
      allow_update_branch: false,
      delete_branch_on_merge: false,
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
      workflows+: {
        allowed_actions: "selected",
      },
      secrets: [
        orgs.newRepoSecret('AZURE_CLIENT_ID') {
          value: "pass:bots/adoptium/azure/azure-client-id",
        },
        orgs.newRepoSecret('AZURE_CLIENT_ID_OIDC') {
          value: "pass:bots/adoptium/azure/azure-client-id-oidc",
        },
        orgs.newRepoSecret('AZURE_CLIENT_SECRET') {
          value: "pass:bots/adoptium/azure/azure-client-secret",
        },
        orgs.newRepoSecret('AZURE_SUBSCRIPTION_ID') {
          value: "pass:bots/adoptium/azure/azure-subscription-id",
        },
        orgs.newRepoSecret('AZURE_TENANT_ID') {
          value: "pass:bots/adoptium/azure/azure-tenant-id",
        },
      ],
      branch_protection_rules: [
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
    orgs.newRepo('marketplace-api.adoptium.net') {
      allow_merge_commit: true,
      allow_squash_merge: false,
      allow_update_branch: false,
      description: "Adoptium Marketplace API 🚀",
      homepage: "https://marketplace-api.adoptium.net",
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
      workflows+: {
        allowed_actions: "selected",
      },
      secrets: [
        orgs.newRepoSecret('AZURE_CLIENT_ID') {
          value: "pass:bots/adoptium/azure/azure-client-id",
        },
        orgs.newRepoSecret('AZURE_CLIENT_ID_OIDC') {
          value: "pass:bots/adoptium/azure/azure-client-id-oidc",
        },
        orgs.newRepoSecret('AZURE_CLIENT_SECRET') {
          value: "pass:bots/adoptium/azure/azure-client-secret",
        },
        orgs.newRepoSecret('AZURE_SUBSCRIPTION_ID') {
          value: "pass:bots/adoptium/azure/azure-subscription-id",
        },
        orgs.newRepoSecret('AZURE_TENANT_ID') {
          value: "pass:bots/adoptium/azure/azure-tenant-id",
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('production') {
          required_approving_review_count: 1,
          required_status_checks+: [
            "build"
          ],
        },
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: 1,
          required_status_checks+: [
            "build"
          ],
        },
      ],
    },
    orgs.newRepo('aqa-systemtest') {
      allow_update_branch: false,
      default_branch: "master",
      delete_branch_on_merge: false,
      description: "Java load testing and other full system application tests",
    },
    orgs.newRepo('aqa-test-tools') {
      allow_update_branch: false,
      default_branch: "master",
      delete_branch_on_merge: false,
      description: "Home of Test Results Summary Service (TRSS) and PerfNext.  These tools are designed to improve our ability to monitor and triage tests at the Adoptium project.  The code is generic enough that it is extensible for use by any project that needs to monitor multiple CI servers and aggregate their results.",
    },
    orgs.newRepo('aqa-tests') {
      allow_update_branch: false,
      default_branch: "master",
      delete_branch_on_merge: false,
      description: "Home of test infrastructure for Adoptium builds",
      homepage: "https://adoptium.net/aqavit",
      topics+: [
        "openjdk-tests",
        "tests"
      ],
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
      allow_merge_commit: true,
      allow_update_branch: false,
      default_branch: "master",
      description: "Github action for building JDKs that utilizes the build scripts from the openjdk-build repo",
    },
    orgs.newRepo('bumblebench') {
      allow_update_branch: false,
      default_branch: "master",
      description: "A microbenchmarking test framework for Eclipse Adoptium",
      topics+: [
        "benchmark",
        "java",
        "performance"
      ],
    },
    orgs.newRepo('secrets') {
      description: "The Secrets Repo for Eclipse Adoptium",
      private: true,
    },
    orgs.newRepo('ci-jenkins-pipelines') {
      allow_auto_merge: true,
      default_branch: "master",
      description: "jenkins pipeline build scripts",
      topics+: [
        "hacktoberfest",
        "jenkins",
        "pipeline"
      ],
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
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_status_checks+: [
            "conclusion"
          ],
        },
      ],
      secrets: [
        orgs.newRepoSecret('DOCKERHUB_USERNAME') {
          value: "pass:bots/adoptium/docker.com/username",
        },
        orgs.newRepoSecret('DOCKERHUB_PASSWORD') {
          value: "pass:bots/adoptium/docker.com/api-token",
        }
      ],
    },
    orgs.newRepo('dash.adoptium.net') {
      allow_auto_merge: true,
      description: "Download tracking dashboard",
      homepage: "https://dash.adoptium.net/",
      topics+: [
        "adoptium",
        "dashboard",
        "eclipse",
        "openjdk",
        "react"
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: 1,
          required_status_checks+: [
            "Lint Code Base",
            "Run CI",
            "netlify:netlify/eclipsefdn-adoptium-dash/deploy-preview"
          ],
        },
      ],
    },
    orgs.newRepo('documentation') {
      archived: true,
      description: "The new documentation for adoptium.net will be initially created in this repo",
      topics+: [
        "documentation",
        "hacktoberfest"
      ],
    },
    orgs.newRepo('documentation-services') {
      archived: true,
    },
    orgs.newRepo('emt4j') {
      allow_merge_commit: true,
      default_branch: "master",
      description: "Eclipse Migration Toolkit for Java",
    },
    orgs.newRepo('github-release-scripts') {
      allow_auto_merge: true,
      default_branch: "master",
      description: "Scripts for release artefacts to GitHub releases",
      topics+: [
        "github"
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
      ],
    },
    orgs.newRepo('infrastructure') {
      default_branch: "master",
      description: "This repo contains all information about machine maintenance.",
      topics+: [
        "ansible",
        "backup",
        "hacktoberfest",
        "infrastructure",
        "infrastructure-systems",
        "nagios"
      ],
      webhooks: [
        orgs.newRepoWebhook('https://ci.adoptium.net/github-webhook/') {
          events+: [
            "push"
          ],
        },
      ],
      secrets: [
        orgs.newRepoSecret('DOCKER_PASSWORD') {
          value: "pass:bots/adoptium/docker.com/password",
        },
        orgs.newRepoSecret('DOCKER_USERNAME') {
          value: "pass:bots/adoptium/docker.com/username",
        },
        orgs.newRepoSecret('DOCKER_TOKEN') {
          value: "pass:bots/adoptium/docker.com/api-token",
        },
        orgs.newRepoSecret('ORKA_VPN_USERNAME') {
          value: "pass:bots/adoptium/macstadium.com/orka-vpn-username",
        },
        orgs.newRepoSecret('ORKA_VPN_PASSWORD') {
          value: "pass:bots/adoptium/macstadium.com/orka-vpn-password",
        },
        orgs.newRepoSecret('ORKA_VPN_SERVER_CERT') {
          value: "pass:bots/adoptium/macstadium.com/orka-vpn-cert",
        },
        orgs.newRepoSecret('ORKA_TOKEN') {
          value: "pass:bots/adoptium/macstadium.com/orka-token",
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
      ],
    },
    orgs.newRepo('installer') {
      allow_auto_merge: true,
      default_branch: "master",
      description: "Installer scripts for Eclipse Temurin binaries",
      topics+: [
        "hacktoberfest",
        "installer"
      ],
      secrets: [
        orgs.newRepoSecret('ARTIFACTORY_PASSWORD') {
          value: "pass:bots/adoptium/artifactory/password",
        },
        orgs.newRepoSecret('ARTIFACTORY_USER') {
          value: "pass:bots/adoptium/artifactory/username",
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
      ],
    },
    newMirrorRepo('aarch32-jdk8u') {},
    newMirrorRepo('aarch32-jdk8u_hg') {
      archived: true,
      description: "Mirror of the Mercurial Forest for the Linux Aarch32 port from",
      homepage: "https://hg.openjdk.java.net/aarch32-port/jdk8u",
    },
    newMirrorRepo('alpine-jdk8u') {},
    newMirrorRepo('jdk') {},
    newMirrorRepo('jdk11u') {},
    newMirrorRepo('riscv-port-jdk11u') {
      default_branch: 'riscv-port'
    },
    newMirrorRepo('jdk11u-fast-startup-incubator') {},
    newMirrorRepo('jdk16u') {},
    newMirrorRepo('jdk17') {
      archived: true,
    },
    newMirrorRepo('jdk17u') {},
    newMirrorRepo('jdk18') {
      archived: true,
    },
    newMirrorRepo('jdk18u') {},
    newMirrorRepo('jdk19') {
      archived: true,
    },
    newMirrorRepo('jdk19u') {},
    newMirrorRepo('jdk20') {
      archived: true,
    },
    newMirrorRepo('jdk20u') {},
    newMirrorRepo('jdk21') {
      archived: true
    },
    newMirrorRepo('jdk21u') {},
    newMirrorRepo('jdk22') {
      archived: true
    },
    newMirrorRepo('jdk22u') {},
    newMirrorRepo('jdk23u') {},
    newMirrorRepo('jdk8u') {},
    newMirrorRepo('jdk8u_hg') {
      archived: true,
    },
    orgs.newRepo('jenkins-helper') {
      default_branch: "master",
      description: "Jenkins Node helper API and helper jobs ",
      topics+: [
        "adoptium",
        "groovy",
        "jenkins",
        "jenkins-helper"
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
      ],
    },
    orgs.newRepo('jmc-build') {
      allow_merge_commit: true,
      description: "Contains the Adoptium specific source code overrides and build pipeline script for the Java Mission Control project.",
      has_wiki: false,
      topics+: [
        "hacktoberfest"
      ],
      secrets: [
        orgs.newRepoSecret('ARTIFACTORY_PASSWORD') {
          value: "pass:bots/adoptium/artifactory/password",
        },
        orgs.newRepoSecret('ARTIFACTORY_USER') {
          value: "pass:bots/adoptium/artifactory/username",
        },
      ],
    },
    orgs.newRepo('marketplace-data') {
      allow_auto_merge: true,
      allow_merge_commit: true,
      description: "The official source of Marketplace data (JSON) for feeding Eclipse Temurin binaries to the Marketplace API 💾",
      has_issues: false,
      homepage: "https://marketplace-api.adoptium.net/",
      secrets: [
        orgs.newRepoSecret('TEMURIN_RSA_PRIVATE') {
          value: "pass:bots/adoptium/github.com/temurin-rsa-private",
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: 1,
          required_status_checks+: [
            "call-adoptium-verifier / validate"
          ],
        },
      ],
    },
    orgs.newRepo('mirror-scripts') {
      default_branch: "master",
      description: "OpenJDK source mirroring scripts used by",
      homepage: "https://ci.adoptium.net/view/git-mirrors/job/git-mirrors/job/adoptium/",
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
      ],
    },
    orgs.newRepo('obsolete---adoptium.net') {
      archived: true,
      description: "Development of the website has moved to https://github.com/adoptium/website-v2",
      homepage: "https://github.com/adoptium/website-v2",
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: null,
          requires_pull_request: false,
        },
      ],
    },
    orgs.newRepo('openj9-systemtest') {
      allow_merge_commit: true,
      allow_update_branch: false,
      default_branch: "master",
      delete_branch_on_merge: false,
      dependabot_security_updates_enabled: true,
      description: "Long running J9 tests",
      private_vulnerability_reporting_enabled: true,
      web_commit_signoff_required: false,
      workflows+: {
        default_workflow_permissions: "write",
      },
      webhooks: [
        orgs.newRepoWebhook('https://ci.eclipse.org/openj9/ghprbhook/') {
          events+: [
            "issue_comment",
            "pull_request",
            "push"
          ],
        },
      ],
    },    
    orgs.newRepo('run-aqa') {
      allow_merge_commit: true,
      default_branch: "master",
      description: "Repository for the Github Action that enables the running of the Adoptium Quality Assurance (AQA) tests",
      topics+: [
        "adoptopenjdk",
        "aqa-tests"
      ],
    },
    orgs.newRepo('temurin') {
      allow_auto_merge: true,
      description: "Eclipse Temurin™ project assets",
      has_wiki: false,
      homepage: "https://adoptium.net/temurin",
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: 1,
        },
      ],
    },
    orgs.newRepo('temurin-build') {
      allow_auto_merge: true,
      default_branch: "master",
      description: "Eclipse Temurin™ build scripts - common across all releases/versions",
      topics+: [
        "cacert",
        "docker-commands",
        "docker-container",
        "docker-group",
        "hacktoberfest",
        "shell-script",
        "temurin"
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master'),
      ],
    },
    orgs.newRepo('temurin-cpe-generator') {
      allow_auto_merge: true,
      description: "A tool to generate NIST CPE directory entries for Eclipse Temurin using the Adoptium API.",
      homepage: "https://adoptium.net/temurin",
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: 1,
        },
      ],
    },
    orgs.newRepo('temurin-vdr-generator') {
      allow_auto_merge: true,
      description: "Scripts for generating Vulnerability Disclosure Reports",
      topics+: [
        "secure-dev"
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main'),
      ],
      secrets: [
        orgs.newRepoSecret('NIST_NVD_TOKEN') {
          value: "pass:bots/adoptium/nist/nist-nvd-api-token",
        },
      ],
    },
    orgs.newRepo('devkit-binaries') {
      allow_merge_commit: true,
      allow_update_branch: false,
      delete_branch_on_merge: false,
      dependabot_security_updates_enabled: true,
      description: "Repository for Adoptium OpenJDK DevKit builds",
      has_issues: false,
    },
    newBinaryRepo('temurin11-binaries') {},
    newBinaryRepo('temurin16-binaries') {},
    newBinaryRepo('temurin17-binaries') {},
    newBinaryRepo('temurin18-binaries') {},
    newBinaryRepo('temurin19-binaries') {},
    newBinaryRepo('temurin20-binaries') {},
    newBinaryRepo('temurin21-binaries') {},
    newBinaryRepo('temurin22-binaries') {},
    newBinaryRepo('temurin23-binaries') {},
    newBinaryRepo('temurin24-binaries') {},
    newBinaryRepo('temurin8-binaries') {},
  ],
}
