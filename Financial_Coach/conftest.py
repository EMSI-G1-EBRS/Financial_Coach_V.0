import sys
import types
from types import SimpleNamespace
import pytest


def _install_stubs():
    # Stub dotenv
    dotenv = types.ModuleType('dotenv')
    def load_dotenv(*args, **kwargs):
        return True
    dotenv.load_dotenv = load_dotenv
    sys.modules['dotenv'] = dotenv

    # Stub langchain_core.messages
    lc_messages = types.ModuleType('langchain_core.messages')
    class _BaseMessage:
        def __init__(self, content: str = ""):
            self.content = content
    class SystemMessage(_BaseMessage):
        pass
    class HumanMessage(_BaseMessage):
        pass
    class AIMessage(_BaseMessage):
        pass
    lc_messages.SystemMessage = SystemMessage
    lc_messages.HumanMessage = HumanMessage
    lc_messages.AIMessage = AIMessage
    sys.modules['langchain_core.messages'] = lc_messages

    # Stub langchain_openai
    lc_openai = types.ModuleType('langchain_openai')
    class ChatOpenAI:
        def __init__(self, *args, **kwargs):
            pass
        def invoke(self, messages):
            # Return an AIMessage-like object
            return lc_messages.AIMessage(content="stub")
    lc_openai.ChatOpenAI = ChatOpenAI
    sys.modules['langchain_openai'] = lc_openai

    # Stub langgraph.graph
    langgraph_graph = types.ModuleType('langgraph.graph')
    class MessagesState(dict):
        pass
    START = "START"
    class StateGraph:
        def __init__(self, *args, **kwargs):
            self.nodes = {}
            self.edges = []
        def add_node(self, name, func):
            self.nodes[name] = func
        def add_edge(self, a, b):
            self.edges.append((a, b))
        def compile(self, checkpointer=None):
            # Return a dummy app with invoke and get_state methods
            class _App:
                def __init__(self):
                    self._state = {'messages': []}
                def invoke(self, payload, config=None):
                    return {'messages': [lc_messages.AIMessage(content='stub reply')]}
                def get_state(self, config=None):
                    return SimpleNamespace(values=self._state)
            return _App()
    langgraph_graph.StateGraph = StateGraph
    langgraph_graph.START = START
    langgraph_graph.MessagesState = MessagesState
    sys.modules['langgraph.graph'] = langgraph_graph

    # Stub langgraph.checkpoint.memory
    langgraph_checkpoint_memory = types.ModuleType('langgraph.checkpoint.memory')
    class MemorySaver:
        def __init__(self, *args, **kwargs):
            pass
    langgraph_checkpoint_memory.MemorySaver = MemorySaver
    sys.modules['langgraph.checkpoint.memory'] = langgraph_checkpoint_memory


@pytest.fixture(autouse=True)
def stub_external_libs():
    # Always install stubs before each test module imports project code
    _install_stubs()
    yield
