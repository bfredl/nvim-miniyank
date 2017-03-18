from .base import Base

class Source(Base):

    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'miniyank'
        self.kind = 'miniyank'

    def on_init(self, context):
        pass


    def gather_candidates(self, context):
        data = self.vim.call("miniyank#read")
        return [{'word': '\\n'.join(d[0]), 'action__data': d}
                for d in data]

