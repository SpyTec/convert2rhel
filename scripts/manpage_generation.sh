#!/bin/bash

# Directory to store the generated manpages
MANPAGE_DIR="man"

echo Generating manpages

VER=$(grep -oP '^Version:\s+\K\S+' packaging/convert2rhel.spec)

echo Generating for version $VER
# Generate a file with convert2rhel synopsis for argparse-manpage
/usr/bin/python -c 'from convert2rhel import toolopts; print("[synopsis]\n."+toolopts.CLI.usage())' > man/synopsis

/usr/bin/python -m pip install argparse-manpage six pexpect

# Generate the manpage using argparse-manpage
PYTHONPATH=. /usr/bin/python /home/runner/.local/bin/argparse-manpage --pyfile man/__init__.py --function get_parser --manual-title="General Commands Manual" --description="Automates the conversion of Red Hat Enterprise Linux derivative distributions to Red Hat Enterprise Linux." --project-name "convert2rhel $VER" --prog="convert2rhel" --include man/distribution --include man/synopsis > "$MANPAGE_DIR/convert2rhel.8"

git status
