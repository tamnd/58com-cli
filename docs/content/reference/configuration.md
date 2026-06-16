---
title: "Configuration"
description: "Environment variables, defaults, and the data directory."
weight: 20
---

job58 needs almost no configuration: it runs anonymously against public
data out of the box. The settings below let you tune politeness and storage.

## Defaults

| Setting | Default | Flag |
|---|---|---|
| Requests | paced and retried on 429/5xx | `--rate`, `--retries` |
| Per-request timeout | 30s | `--timeout` |
| On-disk cache | under the data directory | `--no-cache` to bypass |

## The data directory

Caches and any record store live under one data directory, chosen in this order:

1. `--data-dir`
2. `JOB58_DATA_DIR`
3. `$XDG_DATA_HOME/job58`
4. `~/.local/share/job58`

## Environment variables

Every flag has an environment fallback, prefixed `JOB58_` in
upper case with dashes as underscores. For example:

```bash
export JOB58_RATE=1s        # same as --rate 1s
export JOB58_DATA_DIR=~/data/job58
```

Flags win over environment variables, which win over the built-in defaults.

## Sending records to a store

`--db` tees every emitted record into a store as a side effect of reading, so a
session fills a local database without a separate import step:

```bash
job58 page <path> --db out.db        # SQLite file
job58 page <path> --db 'postgres://...'
```
