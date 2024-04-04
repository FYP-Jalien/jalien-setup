#!/bin/bash

set -e

source ../config/config.sh

chmod +x "$JALIEN/compile.sh"
"$JALIEN/compile.sh" cs
echo "alien-cs.jar created"
