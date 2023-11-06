# PLATFORM
`platform` is the codename of the G8w devops-test.

## Introduction

This repository is a mono-repository that contains all the code for the platform.

This mono-repo is composed of 2 technical sub-projects:

* `.github` (CI/CD pipeline scripts)
* `infra` (infrastructure as code)

The noticeable technologies used in this repository are (not exhaustive):

* [AWS CLI](https://aws.amazon.com/cli/)
* [AWS CloudWatch](https://aws.amazon.com/cloudwatch/)
* [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/)
* [AWS Management Console](https://aws.amazon.com/console/)
* [AWS Organizations](https://aws.amazon.com/organizations/)
* [AWS Profiles](https://aws.amazon.com/cli/)
* [Amazon Web Services (AWS)](https://aws.amazon.com/)
* [GenJS](https://genjs.dev)
* [Git](https://git-scm.com/)
* [GitHub](https://github.com/)
* [GitHub Actions](https://github.com/features/actions)
* [GitHub Packages](https://github.com/features/packages)
* [Hub (for Git, by GitHub)](https://github.com/github/hub)
* [JSON](https://www.json.org/json-fr.html)
* [Javascript (ES6)](http://es6-features.org/)
* [Jest](https://jestjs.io/)
* [Make / Makefile](https://www.gnu.org/software/make/manual/make.html)
* [Markdown](https://guides.github.com/features/mastering-markdown/)
* [NPM](https://www.npmjs.com/)
* [NVM](https://github.com/nvm-sh/nvm)
* [Node.js](https://nodejs.org/en/)
* [Prettier](https://prettier.io/)
* [SSH (for GitHub)](https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account)
* [Terraform](https://www.terraform.io/)
* [Terraform Cloud](https://app.terraform.io/)
* [Yarn](https://yarnpkg.com/)
* [tfenv](https://github.com/tfutils/tfenv)
* [~/.npmrc (for GitHub)](https://docs.github.com/en/packages/using-github-packages-with-your-projects-ecosystem/configuring-npm-for-use-with-github-packages)
* [~/.terraformrc (for Terraform Cloud)](https://app.terraform.io/)


## Our Team's 10 Commandments

1. Always from the root of this repo, work you will
2. Always after git-pulling, executing `make` you will
3. Never on the `develop`, `release`, `master` and `prod` branches, directly committing you will 
4. Never on `aws.amazon.com/console` manually modifying resources you will
5. As often as possible, during the day, git-rebase your feature-branch you will
6. Just after creating your new feature branch, a new `WIP` Pull-Request create you will 
7. ?
8. ?
9. ?
10. ?


## Pre-requisites

Ensure you have the following installed on your local environment, with a versions >= to those displayed:

### Operating System(s)

Whereas you are free to choose the Operating System you want to work on this project, we recommend the following that are compatible with our dev workflow:

* `macOS` (with XCode Command Line Tools installed)
* `Linux` (apt-based)

We do not recommend Windows as an Operating System for working on this project.

### Terminal/Console

Whereas a Terminal/Console is required to work on this project, you can choose whatever professional Terminal/Console program you want. Here is a short list of proposed ones:

* [iTerm2](https://www.iterm2.com/) (macOS only)
* [Linux console](https://en.wikipedia.org/wiki/Linux_console) (Linux only)

We do not recommend Windows-based Terminal/Console for working on this project.

### IDE (Integrated Development Environment)

Whereas an IDE is required to work on this project, you can choose whatever professional IDE to work with Javascript you want. Here is a short list of proposed ones:

* Free: [Microsoft Visual Studio Code](https://code.visualstudio.com/)
* Commercial: [JetBrains WebStorm](https://www.jetbrains.com/fr-fr/webstorm/)

We do not recommend Text-only Editor (Sublime-Text, TextEdit, vi, vim, emacs, ...) for working on this project.

### Required CLI Tools & Settings

#### Git

    $ git --version
    git version 2.24.2 (Apple Git-127)

if not installed, see [Git installation procedure](#install-git)

#### Make / Makefile

    $ make -v
    GNU Make 3.81
    Copyright (C) 2006  Free Software Foundation, Inc.
    This is free software; see the source for copying conditions.
    There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
    PARTICULAR PURPOSE.

    This program built for i386-apple-darwin11.3.0

if not installed, see [Make installation procedure](#install-make).

#### NVM

    $ nvm --version
    0.35.3

if not installed, see [NVM installation procedure](#install-nvm).

#### tfenv

    $ tfenv -v
    tfenv 1.0.2

if not installed, see [tfenv installation procedure](#install-tfenv).

#### Hub (for Git, by GitHub)

    $ git --version
    git version 2.24.2 (Apple Git-127)
    hub version 2.14.2

if not installed, see [Hub installation procedure](#install-hub)

#### SSH (for GitHub)

    $ ssh git@github.com
    PTY allocation request failed on channel 0
    Hi xxxx! You've successfully authenticated, but GitHub does not provide shell access.
    Connection to github.com closed.

if not installed, see [SSH installation procedure](#install-ssh)

#### Node.js

    $ node -v
    v14.3.0

if the displayed version is older:

    $ nvm use
    Found '/Users/.../site-front/.nvmrc' with version <14.3.0>
    Now using node v14.3.0 (npm v6.14.5)

if not installed, see [Node installation procedure](#install-node).

#### Terraform

    $ terraform -v
    Terraform v0.12.26

if not installed, see [Terraform installation procedure](#install-terraform).

#### AWS CLI

    $ aws --version
    aws-cli/2.0.10 Python/3.8.2 Darwin/19.4.0 botocore/2.0.0dev14

if not installed, see [AWS CLI installation procedure](#install-aws-cli).

#### NPM

    $ npm -v
    6.14.5

if not installed, see [NPM installation procedure](#install-npm).

#### AWS Profiles


    $ AWS_PROFILE=g8w-dev aws s3 ls
    2020-06-03 19:21:42 xxxx
    2020-06-03 18:37:03 yyyy


    $ AWS_PROFILE=g8w-preprod aws s3 ls
    2020-06-03 19:21:42 xxxx
    2020-06-03 18:37:03 yyyy


    $ AWS_PROFILE=g8w-prod aws s3 ls
    2020-06-03 19:21:42 xxxx
    2020-06-03 18:37:03 yyyy


if not installed, see [AWS Profiles installation procedure](#install-aws-profiles).

#### ~/.npmrc (for GitHub)

    $ npm whoami --registry https://npm.pkg.github.com
    <your-github-login>

if not installed, see [.npmrc installation procedure](#install-npmrc).

#### Yarn

    $ yarn -v
    1.22.4

if not installed, see [Yarn installation procedure](#install-yarn).

#### ~/.terraformrc (for Terraform Cloud)

    $ cat ~/.terraformrc
    credentials "app.terraform.io" {
      token = "XXXXXXXXXX..."
    }

if not installed, see [Terraformrc installation procedure](#install-terraformrc).




## Installation

    git clone git@github.com:augustinmerle/devops-test.git
    cd platform
    make pre-install
    make


## Development (local)

### Install dependencies

#### All dependencies

    make

#### Project specific dependencies

    make install-root


### Execute tests

#### All tests

    make test

#### Project specific tests



### Start local server (hot-reloaded)

#### Default local server (front only)

    make start

#### Project specific local service



### Build production-ready directory

#### All builds

By default if no ` env=<env>` is provided on the command line, the default value is considered to be `env=dev`:

    make build

...or to specify a target env explicitly:

    make build env=dev
    make build env=preprod
    make build env=prod


#### Project specific build



### Deploy to an environment

As a pre-requisite, you need to have build the production-ready version of the website targeted for the specified `env` (`dev|preprod|prod`)

    make
    make test
    make build env=<env>

where `<env>` must be one of the values: `dev`, `preprod`, `prod`.

The first time you want to deploy from your local environment, you need to initialize terraform locally:

    make infra-init env=<env>

After having built the production-ready static files, you can then execute:

    make provision env=<env>
    make deploy env=<env>

The `provision` command will synchronize the infrastructure resources (on AWS) with the ones described in the Terraform configuration (*.tf files located in the `./infra/environments/<env>/` directory).

The `deploy` command will send and synchronize remote s3 bucket (containing static files served by the CloudFront CDN) with your local `./<deployable-project>/public/` or `./<deployable-project>/build/` directory, and then trigger a cache invalidation on the CloudFront distribution.
You can deploy a single project by executing one of these commands:




## Appendices

### Optional Installation Procedures

#### Install Git

[Follow instructions for your operating system](https://git-scm.com/downloads)

`Acceptance test`

    git --version

... should display the version of Git.

#### Install Make / Makefile

`make` should be already installed on MacOS. For linux installation, search for `install make <name-of-distro>` on google ;)

`Acceptance test`

    make -v

... should display the version of Make.

#### Install NVM

[Follow instructions for your operating system](https://github.com/nvm-sh/nvm)

`Acceptance test`

    nvm --version

... should display `0.35.3` or a higher version.

#### Install tfenv

[Follow instructions for your operating system](https://github.com/tfutils/tfenv)

`Acceptance test`

    tfenv -v

... should display `1.0.2` or a higher version.

#### Install Hub (for Git, by GitHub)

[Follow instructions for your operating system](https://hub.github.com/)

To be able to use `hub` as a transparent wrapper of `git`, add the following to your `~/.bash_profile` / `~/.zshrc file` or equivalent:

    eval "$(hub alias -s)"

`Acceptance test`

    git -v

... should display the version of `Git + Hub`.

#### Install SSH (for GitHub)

An SSH client should already being installed on your system. If not, please add an ssh client using the official installation method for your operating system.
Then, ensure the following is displaying the SSH client version:

    $ ssh -V
    OpenSSH_8.1p1, LibreSSL 2.7.3

You need to have a personal ssh key in order to access th GitHub restricted projects of your organization.
If not yet set on your local environment and on your GitHub account, please [follow instructions for your operating system](https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account)

`Acceptance test`

    ssh git@github.com

... should display a GitHub ssh server greeting with your username.

#### Install Node.js

You have to install NVM first. Then:

    nvm install
    nvm use

`Acceptance test`

    node -v

... should display `v14.3.0` or a higher version.

#### Install Terraform

You have to install tfenv first. Then:

    tfenv install

It will install the Terraform version specified in the `./.terraform-version` file.

`Acceptance test`

    terraform -v

... should display `0.12.26` or a higher version.

#### Install AWS CLI

[Follow instructions for your operating system](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

`Acceptance test`

    aws --version

... should display `2.0.10` or a higher version.

#### Install NPM

You have to install NVM and NODE first. Then:

    nvm install
    nvm use

`Acceptance test`

    npm -v

... should display `6.14.5` or a higher version.

#### Install AWS Profiles

AWS CLI is using configuration files located in your home directory (as one of its method) to authenticate your api requests when using the tool.
There are 2 important files:

* `~/.aws/credentials`: contains your personal credentials
* `~/.aws/config`: contains additional profiles (so-called roles to assume)

To set your profiles, follow these steps:

* ensure you have a personal IAM user and proper credentials that were provided to you (a so-called `Access Key Id` and `Secret Access Key`). These are your personal API credentials that you must not share with others. If not, please contact the Team Tech Lead.
* ensure you have the following content to your `~/.aws/config` file (or create it with that content):


    [profile g8w-dev]
    role_arn=arn:aws:iam::380343732230:role/OrganizationAccountAccessRole
    source_profile=g8w

    [profile g8w-preprod]
    role_arn=arn:aws:iam::380343732230:role/OrganizationAccountAccessRole
    source_profile=g8w

    [profile g8w-prod]
    role_arn=arn:aws:iam::865321437484:role/OrganizationAccountAccessRole
    source_profile=g8w


* ensure you have the following content (at least) in your `~/.aws/credentials` file (or create it with that content):


    [g8w]
    aws_access_key_id = <your-AKI-here>
    aws_secret_access_key = <your-SAK-here>


`Acceptance test`

    AWS_PROFILE=g8w-dev aws s3 ls
    AWS_PROFILE=g8w-preprod aws s3 ls
    AWS_PROFILE=g8w-prod aws s3 ls

... should display a non empty list of s3 buckets for DEV environment.

#### Install ~/.npmrc (for GitHub)

Ensure first to have create a GitHub Personal Token, with scope package read/write enabled, and pick it up.

Then, add the following content to your `~/.npmrc` file (create it if not exist):

    //npm.pkg.github.com/:_authToken=<your-personal-github-token-with-packages-read-write-scope-enabled>
    @g8wdev:registry=https://npm.pkg.github.com

`Acceptance test`

    npm whoami --registry https://npm.pkg.github.com

... should display your personal GitHub username.

#### Install Yarn

[Follow instructions for your operating system](https://classic.yarnpkg.com/fr/docs/install)

`Acceptance test`

    yarn -v

... should display `1.22.4` or a higher version.

#### Install ~/.terraformrc (for Terraform Cloud)

* if not yet provided to you, request an access to app.terraform.io to the Team Tech Lead
* browse to https://app.terraform.io
* log in with your account
* go to upper right corner, click on your avatar
* click User Settings link
* go to Tokens menu item in the left
* if not yet created, create a new personal Token and pick it up (so-called `the token`)

Then add the following content to your `~/.terraformrc` file (create it if not exist):

    credentials "app.terraform.io" {
      token = "the token"
    }

if needed, here is the [Official Terraform Credentials documentation](https://www.terraform.io/docs/commands/cli-config.html#credentials-1)

`Acceptance test`

    $ cat ~/.terraformrc
    credentials "app.terraform.io" {
      token = "XXXXXXXXXX..."
    }






