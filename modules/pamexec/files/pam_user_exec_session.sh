#!/bin/bash

# execute all scripts as user #
if [ -d "/etc/pam_user_session_exec.d" ]; then
   run-parts /etc/pam_user_session_exec.d
fi

