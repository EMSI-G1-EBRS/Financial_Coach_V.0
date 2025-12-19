import types
from types import SimpleNamespace
from langchain_core.messages import HumanMessage, AIMessage
from financial_agent import FinancialCoachAgent


def test_chat_returns_mocked_response(mocker):
    agent = FinancialCoachAgent()

    mocked_response = {"messages": [AIMessage(content="Ceci est une réponse mock")]}
    mocker.patch.object(agent.app, 'invoke', return_value=mocked_response)

    result = agent.chat("Bonjour", thread_id="123")

    assert result == "Ceci est une réponse mock"


def test_get_chat_history_formats_messages(mocker):
    agent = FinancialCoachAgent()

    fake_state = SimpleNamespace(values={
        'messages': [
            HumanMessage(content="Bonjour"),
            AIMessage(content="Salut")
        ]
    })

    mocker.patch.object(agent.app, 'get_state', return_value=fake_state)

    history = agent.get_chat_history(thread_id="123")

    assert history == [
        {"role": "user", "content": "Bonjour"},
        {"role": "assistant", "content": "Salut"}
    ]
