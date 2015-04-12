#!/usr/bin/env python

import numpy as np
import pandas as pd
from sklearn.naive_bayes import MultinomialNB


train = pd.read_csv('../data/train.csv')
test_indexes = pd.read_csv('../partitions/test_indexes.csv')
test = pd.read_csv('../data/test.csv')

train.set_index(train.id, inplace=True)
labels = train.target.str.replace("Class_", "").astype("int")
train.drop(["id", "target"], axis=1, inplace=True)

model = MultinomialNB()
model.fit(train, labels)


def log_loss(pred, true):
    """
    `pred` is an N by 9 matrix of probabilities
    `true` is the true labels (integers, 1 to 9)
    """
    bound_pred = np.maximum(np.minimum(pred, 1 - 1e-15), 1e-15)
    normed_pred = bound_pred / bound_pred.sum(axis=1, keepdims=True)
    if type(true).__name__ == 'Series':
        true = true.values
    n = len(true)
    probs_of_correct = [normed_pred[i, true[i]-1] for i in range(n)]
    return -np.log(probs_of_correct).sum() / n


def cross_val(model):
    raise NotImplementedError
