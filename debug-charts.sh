#!/usr/bin/env bash
set -e

for path in helm/*/ ; do
    chart=$(basename "$path")
    echo "Testing $chart"
    for configpath in "testconfigs/$chart"/*.yaml ; do
        if [[ ! -e "$configpath" ]]; then
            echo "No test configs found for chart $chart"
            continue
        fi
        filename=$(basename -- "$configpath")
        config="${filename%.*}"
        ns="$chart-${config%.*}"
        echo "status chart $chart w/ cfg $configpath in ns $ns"
        if ! helm status test-app -n "$ns"; then
            echo "Unable to fetch helm status for release test-app in namespace $ns"
            kubectl get namespace "$ns" >/dev/null 2>&1 && kubectl get all -n "$ns" || true
        fi
    done
done
