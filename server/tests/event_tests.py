"""
Description:    Testing suite for the Event class to verify it works as intended.
Author:         Jordan Bourdeau
Date:           11/13/23
"""

from server.game_logic.event import Event

import unittest


class TestEventClass(unittest.TestCase):
    def test_event_creation(self):
        parameters = {'param1': 'value1', 'param2': 'value2'}
        event = Event(parameters)
        self.assertEqual(event.parameters, parameters)

    def test_to_camel_case(self):
        event = Event({})
        self.assertEqual(event.to_camel_case('snake_case_string'), 'snakeCaseString')
        self.assertEqual(event.to_camel_case('another_example'), 'anotherExample')

    def test_serialize(self):
        parameters = {'param_one': 'value1', 'param_two': 'value2'}
        event = Event(parameters)
        expected_result = {'paramOne': 'value1', 'paramTwo': 'value2'}
        self.assertEqual(event.serialize(), expected_result)


if __name__ == '__main__':
    unittest.main()
