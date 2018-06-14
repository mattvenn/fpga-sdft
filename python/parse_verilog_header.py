import re

class ParseParams():

    def __init__(self, filename):
        self.filename = filename
        self.params = {}

    def parse(self):
        with open(self.filename) as fh:
            for line in fh.readlines():
                m = re.search('^localparam (\w+) = (\d+);', line)
                if m is not None:
                    self.params[m.group(1)] = int(m.group(2))
        return self.params



if __name__ == '__main__':
    pp = ParseParams('tests/localparams.vh')
    params = pp.parse()
    from pprint import pprint
    pprint(params)
