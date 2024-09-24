import os

# From: https://superuser.com/a/1593856
# Usage:
# Put the follwing at the end of the your shell rc file
# eval $(python3 $HOME/.local/bin/clean_env_PATH.py)

# grab $PATH
path = os.environ['PATH'].split(':')

# normalize all paths
path = map(os.path.normpath, path)

# remove duplicates via a dictionary
clean = dict.fromkeys(path)

# combine back into one path
clean_path = ':'.join(clean.keys())

# dump to stdout
print(f"PATH={clean_path}")
