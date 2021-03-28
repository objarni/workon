class State:
    def __init__(self):
        self.data = {}

    def add_client(self, alias, workon, timestamp):
        self.data[alias] = (workon, timestamp)
        to_delete = [alias for alias in self.data
                     if timestamp - self.data[alias][1] > 30]
        while len(to_delete) > 0:
            del self.data[to_delete[0]]
            del to_delete[0]

    def __repr__(self):
        result = ""
        for alias, data in self.data.items():
            workon, timestamp = data
            result += f"{alias} is working on {workon} since time={timestamp}\n"
        return result

    def get_working_clients(self):
        return [(alias, self.data[alias][0]) for alias in self.data]
