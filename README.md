# MYPROJECT

## Introduction

This repository is a mono-repository that contains all the code for the platform.


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
* [JSON](https://www.json.org/json-fr.html)
* [Javascript (ES6)](http://es6-features.org/)
* [Jest](https://jestjs.io/)
* [Make / Makefile](https://www.gnu.org/software/make/manual/make.html)
* [Markdown](https://guides.github.com/features/mastering-markdown/)
* [NPM](https://www.npmjs.com/)
* [NVM](https://github.com/nvm-sh/nvm)
* [Node.js](https://nodejs.org/en/)
* [Prettier](https://prettier.io/)
* [Yarn](https://yarnpkg.com/)


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

#### Git

    $ git --version
    git version 2.24.2 (Apple Git-127)

if not installed, see [Git installation procedure](#install-git)

#### Node.js

    $ node -v
    v14.3.0

if the displayed version is older:

    $ nvm use
    Found '/Users/.../site-front/.nvmrc' with version <14.3.0>
    Now using node v14.3.0 (npm v6.14.5)

if not installed, see [Node installation procedure](#install-node).

#### AWS CLI

    $ aws --version
    aws-cli/2.0.10 Python/3.8.2 Darwin/19.4.0 botocore/2.0.0dev14

if not installed, see [AWS CLI installation procedure](#install-aws-cli).

#### NPM

    $ npm -v
    6.14.5

if not installed, see [NPM installation procedure](#install-npm).

#### AWS Profiles


    $ AWS_PROFILE=mycompany-dev aws s3 ls
    2020-06-03 19:21:42 xxxx
    2020-06-03 18:37:03 yyyy


    $ AWS_PROFILE=mycompany-test aws s3 ls
    2020-06-03 19:21:42 xxxx
    2020-06-03 18:37:03 yyyy


    $ AWS_PROFILE=mycompany-preprod aws s3 ls
    2020-06-03 19:21:42 xxxx
    2020-06-03 18:37:03 yyyy


    $ AWS_PROFILE=mycompany-prod aws s3 ls
    2020-06-03 19:21:42 xxxx
    2020-06-03 18:37:03 yyyy


if not installed, see [AWS Profiles installation procedure](#install-aws-profiles).

#### Yarn

    $ yarn -v
    1.22.4

if not installed, see [Yarn installation procedure](#install-yarn).




## Installation

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
    make build env=test
    make build env=preprod
    make build env=prod


#### Project specific build



### Deploy to an environment

As a pre-requisite, you need to have build the production-ready version of the website targeted for the specified `env` (`dev|test|preprod|prod`)

    make
    make test
    make build env=<env>

where `<env>` must be one of the values: `dev`, `test`, `preprod`, `prod`.

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

#### Install Git

[Follow instructions for your operating system](https://git-scm.com/downloads)

`Acceptance test`

    git --version

... should display the version of Git.

#### Install Node.js

You have to install NVM first. Then:

    nvm install
    nvm use

`Acceptance test`

    node -v

... should display `v14.3.0` or a higher version.

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


    [profile mycompany-dev]
    role_arn=arn:aws:iam::XXXXXXXXXXXX:role/OrganizationAccountAccessRole
    source_profile=mycompany

    [profile mycompany-test]
    role_arn=arn:aws:iam::XXXXXXXXXXXX:role/OrganizationAccountAccessRole
    source_profile=mycompany

    [profile mycompany-preprod]
    role_arn=arn:aws:iam::XXXXXXXXXXXX:role/OrganizationAccountAccessRole
    source_profile=mycompany

    [profile mycompany-prod]
    role_arn=arn:aws:iam::YYYYYYYYYYYY:role/OrganizationAccountAccessRole
    source_profile=mycompany


* ensure you have the following content (at least) in your `~/.aws/credentials` file (or create it with that content):


    [mycompany]
    aws_access_key_id = <your-AKI-here>
    aws_secret_access_key = <your-SAK-here>


`Acceptance test`

    AWS_PROFILE=mycompany-dev aws s3 ls
    AWS_PROFILE=mycompany-test aws s3 ls
    AWS_PROFILE=mycompany-preprod aws s3 ls
    AWS_PROFILE=mycompany-prod aws s3 ls

... should display a non empty list of s3 buckets for DEV environment.

#### Install Yarn

[Follow instructions for your operating system](https://classic.yarnpkg.com/fr/docs/install)

`Acceptance test`

    yarn -v

... should display `1.22.4` or a higher version.





