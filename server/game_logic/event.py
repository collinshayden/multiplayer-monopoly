"""
Description:    Class representing the information that will be stored from each event to facilitate client-side actions
Date:           11/11/2023
Author:         Aidan Bonner
"""


class Event:

    def __init__(self, name: str, screen_change: bool, popup: bool, prompt_input: bool, append_to_feed: bool,
                 update_info: bool) -> None:
        """
        Description:    Class holding the name of the event and what will happen on the client because of it.
        :returns:       None.
        """
        self.name: str = name
        self.screen_change: bool = screen_change
        self.popup: bool = popup
        self.prompt_input: bool = prompt_input
        self.append_to_feed: bool = append_to_feed
        self.update_info: bool = update_info

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
            "screenChange": self.screen_change,
            "popup": self.popup,
            "promptInput": self.prompt_input,
            "appendToFeed": self.append_to_feed,
            "updateInfo": self.update_info
        }
        return client_bindings
