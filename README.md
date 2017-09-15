# Naust

## Simple repository management

This project will implement a simple repository management pattern. Its main
intent is that all upstream content referenced while building infrastrcture
artifacts must be versioned and available.

Right now this repository only contains design notes showing some of the
preliminary design.

## Repositories

The main object Naust operates on is a repository.

### Repository _configuration_

Each repository is defined in Naust as configuration data. The configuration can
contain an unlimited number of repos but the initial design only operate on a
single repo per run. This is a deliberate design limitation (for now?).

#### Example repository configuration

```yaml
centos-base:
  type: yum
  mode: mirror
  source:
    - "https://url1.yay.no"
    - "https://url2.yay.se"

safespring-backup-el7:
  type: yum
  mode: local
  source:
    - "/var/lib/jenkins/builds"

hashicorp:
  type: file
  plugin: hashicorp
  options:
    - packer
    - terraform

rabbitmq:
  type: file
  mode: mirror
```

### A _mirror_ of content

The repository _mirror_ is data fetched upstream. It serves as the input for
further processing and management.

### A _snapshot_ of a given repository

Naust generates and manages _snapshots_ of a given repository. This is done
using the _mirror_ data as input. Different types of snapshots exists depending
on repository type, to cover different use cases.

## Example filesystem

Naust data always live relative to the configuration file.

```shell
.
├── mirror
│   ├── file
│   │   └── hashicorp
│   └── yum
│       ├── centos-base
│       └── safespring-backup-el7
└── snapshot
    ├── file
    │   └── hashicorp
    └── yum
        ├── centos-base
        │   ├── 2017-09-10T09:49:13Z
        │   └── latest -> 2017-09-10T09:49:13Z
        └── safespring-backup-el7
            ├── 2017-09-14T12:48:31Z
            └── latest -> 2017-09-14T12:48:31Z
```