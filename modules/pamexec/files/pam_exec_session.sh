#! /bin/sh

# only when opening session #
if [ "$PAM_TYPE" != "open_session" ]; then
   exit 0
fi

# only for graphical session #
if [ "$XDG_SESSION_TYPE" != "x11" ] && [ "$XDG_SESSION_TYPE" != "wayland" ]; then
   exit 0
fi

# only user graphical session #
if [ "$XDG_SESSION_CLASS" != "user" ]; then
   exit 0
fi

# only when path is defined #
if [ -z "$PATH" ]; then
   exit 0
fi

exec /usr/sbin/runuser -u "$PAM_USER" "/usr/bin/pam_user_exec_session.sh"
