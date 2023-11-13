"""
Description:    Class representing the information that will be stored from each event to facilitate client-side actions
Date:           11/11/2023
Author:         Aidan Bonner
"""


class Event:

    def __init__(self, name: str, info: dict) -> None:
        """
        Description:    Class holding the name of the event and what will happen on the client because of it.
        :returns:       None.
        """
        self.name: str = name
        self.info: dict = info

    def to_camel_case(self, in_str: str) -> str:
        """
        Description:    Converts a snake_case string to a camelCase string.
        Source:         https://www.geeksforgeeks.org/python-convert-snake-case-string-to-camel-case/
        :returns:       The camel case string.
        """
        temp = in_str.split("_")
        out_str = temp[0] + "".join(i.title() for i in temp[1:])
        return out_str

    def serialize(self) -> dict:
        camel_name = self.to_camel_case(self.name)
        client_bindings = {
            "name": camel_name,
        }
        for i in self.info:
            client_bindings.update(i)
        return client_bindings
