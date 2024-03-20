#!/bin/bash

set -e

source "$1"

chmod +x "$JALIEN/compile.sh"
"$JALIEN/compile.sh" cs
echo "alien-cs.jar created"
