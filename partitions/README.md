# standard cross-validation partitions

In order to have exactly replicable/comparable cross-validation
scoring across languages, the file `test_indexes.csv` specifies a
ten-fold partition for testing.

The training data file has a header and 61,878 data rows, each
identified by an `id` (in the first column).

The script `make_partitions.py` (run from this directory) creates the
file `test_indexes.csv` which contains ten columns, each corresponding
to a test partition with 6,187 `id`s. The complement of the test
partition is the corresponding train partition.
