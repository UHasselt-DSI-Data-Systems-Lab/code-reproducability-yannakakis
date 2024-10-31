from __future__ import annotations


class Field:
    """Schema field. Contains optional table name and field name."""

    def __init__(self, table_name: str | None, field_name: str):
        self.table_name = table_name
        self.field_name = field_name

    def __str__(self):
        if self.table_name is None:
            return self.field_name
        return f"{self.table_name}.{self.field_name}"

    def __repr__(self):
        return str(self)

    def __eq__(self, other: Field):
        return self.cmp_qualified(other)

    def __hash__(self) -> int:
        return hash(repr(self))

    def to_json(self):
        return self.__dict__

    @staticmethod
    def from_json(json_data) -> Field:
        return Field(**json_data)

    @staticmethod
    def from_str(field_str: str) -> Field:
        parts = field_str.split(".")
        if len(parts) == 1:
            return Field(None, parts[0])
        return Field(parts[0], parts[1])

    def to_unqualified(self) -> Field:
        """Return a new Field object without the table name."""
        return Field(None, self.field_name)

    def cmp_unqualified(self, other: Field):
        """Compare fields without considering table names."""
        return self.field_name == other.field_name

    def cmp_qualified(self, other: Field):
        """Compare fields considering table names."""
        return self.table_name == other.table_name and self.field_name == other.field_name

    def replace_alias(self, aliases: dict[str, str]):
        """If table name is an alias, replace it with the actual table name.

        Args:
            aliases (dict[str, str]): Mapping of alias to actual table name."""
        if self.table_name in aliases:
            self.table_name = aliases[self.table_name]
