#!/usr/bin/env python

import pandas as pd


train = pd.read_csv('../data/train.csv')
test_indexes = pd.read_csv('../partitions/test_indexes.csv')
test = pd.read_csv('../data/test.csv')
