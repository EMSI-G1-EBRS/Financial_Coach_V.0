import json
import pytest


@pytest.fixture()
def client():
    # Import here so that conftest stubs are applied first
    import api
    app = api.app
    app.testing = True
    with app.test_client() as c:
        yield c


def test_health_ok(client):
    resp = client.get('/health')
    assert resp.status_code == 200
    assert resp.get_json() == {"status": "ok"}


def test_chat_success(client, mocker):
    import api
    mocked_agent = mocker.patch('api.agent')
    mocked_agent.chat.return_value = "Réponse du coach"

    payload = {"message": "test", "user_id": "123"}
    resp = client.post('/chat', data=json.dumps(payload), content_type='application/json')

    assert resp.status_code == 200
    data = resp.get_json()
    assert data["response"] == "Réponse du coach"
    assert data["user_id"] == "123"
    mocked_agent.chat.assert_called_once_with("test", thread_id="123")


def test_chat_error_missing_message(client):
    payload = {"user_id": "123"}
    resp = client.post('/chat', data=json.dumps(payload), content_type='application/json')

    assert resp.status_code == 400
    data = resp.get_json()
    assert 'error' in data


def test_history_returns_mocked_list(client, mocker):
    import api
    mocked_agent = mocker.patch('api.agent')
    mocked_agent.get_chat_history.return_value = [{"role": "user", "content": "Test"}]

    resp = client.get('/history?user_id=123')

    assert resp.status_code == 200
    data = resp.get_json()
    assert data["history"] == [{"role": "user", "content": "Test"}]
    assert data["user_id"] == "123"
    mocked_agent.chat.assert_called_once_with(
        "test",
        thread_id="123",
        language=None,
        persona=None,
    )
