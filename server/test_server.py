"""
- adding a new client in empty state
- adding a new client, when an old client is more than 30 s old
- adding a new client, when a prev client is less than 30 s old
"""
from approvaltests import verify, verify_as_json
from approvaltests.reporters import PythonNativeReporter

from state import State


def test_adding_client():
    state = State()
    state.add_client('Olof', 'rescue', timestamp=5)
    verify(repr(state), reporter=PythonNativeReporter())


def test_adding_second_client_within_30_seconds():
    state = State()
    state.add_client('Olof', 'rescue', timestamp=5)
    state.add_client('Tor', 'polarbear', timestamp=25)
    verify(repr(state), reporter=PythonNativeReporter())


def test_adding_second_client_after_31_seconds():
    state = State()
    state.add_client('Olof', 'rescue', timestamp=5)
    state.add_client('Tor', 'polarbear', timestamp=36)
    verify(repr(state), reporter=PythonNativeReporter())


def test_get_working_clients():
    state = State()
    state.add_client('Olof', 'rescue', timestamp=5)
    state.add_client('Tor', 'polarbear', timestamp=21)
    verify_as_json(state.get_working_clients(), reporter=PythonNativeReporter())
