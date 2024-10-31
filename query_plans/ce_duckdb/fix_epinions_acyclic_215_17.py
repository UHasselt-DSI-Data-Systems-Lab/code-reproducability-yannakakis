# Query epinions_acyclic_215_17 contains a join condition 'epinions75902.s = epinions75902.s',
# which should be 'epinions75904.s = epinions75902.s'.
# Also, hash join condition 'epinions75902.s = epinions75891.s'  should be replaced by 'epinions75904.s = epinions75891.s'.
# This script fixes this.

infiles = [
    "./3_no_filters_and_projections/epinions_acyclic_215_17/run_1.json",
]

for infile in infiles:
    with open(infile, "r") as f:
        data = f.read()

    data = data.replace(
        '"extra_info": "INNER\\nepinions75902.s = epinions75902.s',
        '"extra_info": "INNER\\nepinions75904.s = epinions75902.s',
    )

    data = data.replace(
        '"extra_info": "INNER\\nepinions75902.s = epinions75891.s',
        '"extra_info": "INNER\\nepinions75904.s = epinions75891.s',
    )

    with open(infile, "w") as f:
        f.write(data)
