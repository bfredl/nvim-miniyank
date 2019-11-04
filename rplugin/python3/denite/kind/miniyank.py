from .base import Base
from denite.util import debug

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

    def action_delete(self, context):
        indexes = [x['action__index'] for x in context['targets']]
        indexes.sort(reverse=True)
        data = self.vim.call('miniyank#read')
        for x in indexes:
            del data[x]
        self.vim.call('miniyank#write', data)
        debug(self.vim, f'[miniyank] {len(indexes)} item(s) deleted')
