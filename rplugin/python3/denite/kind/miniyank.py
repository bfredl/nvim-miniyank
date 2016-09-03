from .base import Base

class Kind(Base):

    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'miniyank'
        self.default_action = "put"

    def action_put(self, context):
        target = context['targets'][0]
        data = target['action__data']
        data = self.vim.call("miniyank#drop", data,  'p')

    def action_Put(self, context):
        target = context['targets'][0]
        data = target['action__data']
        data = self.vim.call("miniyank#drop", data,  'P')

