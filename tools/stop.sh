#!/bin/bash
D=$(cd $(dirname $0); pwd)

$D/run/pg-17/stop
$D/run/pg-18/stop