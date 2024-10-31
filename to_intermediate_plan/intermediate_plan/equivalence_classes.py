from .field import Field


class EquivalenceClasses:
    def __init__(self):
        self.classes: list[set[Field]] = []

    def __str__(self) -> str:
        return str(self.classes)

    def __repr__(self) -> str:
        out = ""
        for eq_class in self.classes:
            out += f"\t - {eq_class}\n"
        return out

    def idx_of_class(self, field: Field) -> int | None:
        """Get the index of the equivalence class that contains the given field."""

        for idx, eq_class in enumerate(self.classes):
            if field in eq_class:
                return idx
        return None

    def update(self, join_on: list[tuple[Field, Field]]):
        """Update equivalence classes with a new equijoin condition."""

        if len(join_on) > 1:
            raise NotImplementedError(
                "Join with more than one equijoin condition is not implemented yet."
            )

        left, right = join_on[0]

        left_class_id = self.idx_of_class(left)
        right_class_id = self.idx_of_class(right)

        if left_class_id is None and right_class_id is None:
            # Neither field is in any class, create a new equivalence class
            new_class = {left, right}
            self.classes.append(new_class)
        elif left_class_id is None and right_class_id is not None:
            # Left field is not in any class, add it to the class of the right field
            self.classes[right_class_id].add(left)
        elif left_class_id is not None and right_class_id is None:
            # Right field is not in any class, add it to the class of the left field
            self.classes[left_class_id].add(right)
        else:
            # assertion below is to make type checker happy
            assert left_class_id is not None and right_class_id is not None

            if left_class_id != right_class_id:
                # merge two classes
                left_class = self.classes[left_class_id]
                right_class = self.classes[right_class_id]
                new_class = left_class.union(right_class)

                self.classes[left_class_id] = new_class
                del self.classes[right_class_id]

    def get_equivalence_class(self, field: Field) -> set[Field] | None:
        """Get the equivalence class that contains the given field.
        Returns None if the field is not in any class."""

        for eq_class in self.classes:
            if field in eq_class:
                return eq_class

        return None
