import json
import time

from bottle import route, run
from state import State

state = State()


@route("/<alias>/workon/<workingon>")
def heartbeat(alias, workingon):
    """Receive heartbeat from alias, and return all available data"""
    state.add_client(alias, workingon, time.time())
    print(state)
    return json.dumps(state.get_working_clients())


if __name__ == "__main__":
    run(host="0.0.0.0", port=8335)
