#! /bin/bash
if [ "$1" == 'puppet' ] && [ -e '/var/lib/puppet/state/agent_catalog_run.lock' ]; then
  exit 101
fi
