#!/bin/bash

set -e

# clean and shutdown so that we're starting from a known state
bazel clean
bazel shutdown

echo -e "\nExpected: 1"
bazel run //:echo_nargs 2>/dev/null

echo -e "\nExpected: 3"
bazel run //:echo_nargs -- a b 2>/dev/null

echo -e "\nExpected: 3"
bazel run --run_under="exec" //:echo_nargs -- a b 2>/dev/null

echo -e "\nExpected: 3"
runcmd="$(mktemp /tmp/bazel-run.XXXXXX)" || { echo "Could not create tmp file"; exit 1; }
bazel run --script_path="$runcmd" //:echo_nargs -- a b 2>/dev/null
"$runcmd"

echo -e "\nExpected: 5"
runcmd="$(mktemp /tmp/bazel-run.XXXXXX)" || { echo "Could not create tmp file"; exit 1; }
bazel run --script_path="$runcmd" //:echo_nargs -- a b 2>/dev/null
"$runcmd" 1 2

echo -e "\nExpected: 3"
runcmd="$(mktemp /tmp/bazel-run.XXXXXX)" || { echo "Could not create tmp file"; exit 1; }
bazel run --run_under="exec" --script_path="$runcmd" //:echo_nargs -- a b &>/dev/null
"$runcmd"

echo -e "\nExpected: 5"
runcmd="$(mktemp /tmp/bazel-run.XXXXXX)" || { echo "Could not create tmp file"; exit 1; }
bazel run --run_under="exec" --script_path="$runcmd" //:echo_nargs -- a b 2>/dev/null
"$runcmd" 1 2
