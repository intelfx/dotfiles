#!/bin/bash

/usr/lib/kde4/libexec/polkit-kde-authentication-agent-1
eval "export $(/usr/bin/gnome-keyring-daemon --start)"
