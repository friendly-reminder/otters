#!/usr/bin/env python

import pandas as pd
import random


test_indexes = pd.DataFrame()

indexes = pd.read_csv('../data/train.csv')['id']
random.seed(42)
random.shuffle(indexes)

size = int(len(indexes) / 10)

for i in range(1, 11):
    test_indexes['test{}'.format(i)] = indexes[(i-1)*size:i*size].values

test_indexes.to_csv('test_indexes.csv', index=False)
