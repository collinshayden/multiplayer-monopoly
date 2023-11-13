"""
Description:    Class representing the information that will be stored from each event to facilitate client-side actions
Date:           11/11/2023
Author:         Aidan Bonner
"""


class Event:

    def __init__(self, parameters: dict) -> None:
        """
        Description:    Class holding the name of the event and information needed for the client side to update.
        :returns:       None.
        """
        self.parameters: dict = parameters

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
        """
        Description:    Method to serialize Event data into JSON format to be read in client-side.
        :return:        Dictionary of camelCase keys to the appropriate values
        """
        return {self.to_camel_case(key): val for key, val in self.parameters.items()}
