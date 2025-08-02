#!/bin/bash
grep -rl "package:restaurant/" lib/ | xargs sed -i 's/package:restaurant\//package:dukascango\//g'
