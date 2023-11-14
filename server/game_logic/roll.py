"""
Description:    Class representing the information for a roll entry.
Date:           11/03/2023
Author:         Alex Hall
"""

from typing import Any


class Roll:
    def __init__(self, first=None, second=None):
        self.first: int = first
        self.second: int = second

    @property
    def is_doubles(self) -> bool:
        return self.first == self.second

    @property
    def total(self) -> int:
        return self.first + self.second

    def to_dict(self) -> dict[str, Any]:
        """
        Description: Method used as input to the serializer used in generating network communications with the client.
                     This function is used as an intermediary representation of the class' data where translations
                     from the frontend (Python) naming conventions to the backend (Flutter/Dart) naming conventions.
        :return: Dictionary from strings to any other data type.
        """
        client_bindings = {
           "first": self.first,
           "second": self.second
        }
        return client_bindings
