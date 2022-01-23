#!/usr/bin/env python3
#
# Problem:  Cannot change the framebuffer font size with `setfont` from within
#           tmux because it doesn't have perms to the tty
# Solution: Start this daemon before starting tmux and have it listen on a unix
#           socket, then have tmux send commands to the socket to change the font.
#
# Usage:
#
#     # Make the communication socket
#     mkfifo ~/fontsize-fifo
#     # Start daemon outside of tmux
#     python3 fb-setfont.py ~/fontsize-fifo &
#     # Change scale at any time via socket
#     echo 1 > ~/fontsize-fifo
#     echo 2 > ~/fontsize-fifo
#
# There's probably something better I can do with CAP_SYS_TTY_CONFIG but this
# was easier lol

import os
import sys
import select

def setscale(scale):
    assert(scale in [1,2])
    scalearg = ''
    if scale == 2:
        scalearg = '-d '

    stream = os.popen(f'setfont {scalearg}Lat2-Terminus16')
    output = stream.read()
    print(output, end='')

def main():
    socket_file = sys.argv[1]

    while True:
        with open(socket_file, 'r') as f:
            select.select([f], [], [f])
            line = f.readline().strip()
            try:
                setscale(int(line))
            except ValueError:
                pass

if __name__ == '__main__':
    main()
