# Query 28 contains a filter (u.Id >= 2), but the child node is a sequential scan with output schema [p.Id, p.OwnerUserId].
# The correct filter expression should be (p.OwnerUserId >= 2) instead of (u.Id >= 2).
# This script fixes this.

infiles = [
    "./3_no_filters_and_projections/28/run_1.json",
]

for infile in infiles:
    try:
        f = open(infile, "r")
        data = f.read()

        data = data.replace(
            '"extra_info": "(u.Id >= 2)\\n[INFOSEPARATOR]\\n',
            '"extra_info": "(p.OwnerUserId >= 2)\\n[INFOSEPARATOR]\\n',
        )

        with open(infile, "w") as f:
            f.write(data)

    except FileNotFoundError:
        # Then there is nothing to fix.
        pass
