#!/bin/bash
D=$(cd $(dirname $0); pwd)

$D/run/pg-17/start
$D/run/pg-18/start