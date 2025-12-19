from flask import Flask, request, jsonify
from flask_cors import CORS
from financial_agent import FinancialCoachAgent
import uuid

app = Flask(__name__)
CORS(app)  # autorise les appels depuis le frontend

# Initialiser l'agent (une seule fois au démarrage)
agent = FinancialCoachAgent()

@app.route('/chat', methods=['POST'])
def chat():
    """Endpoint pour envoyer un message à l'agent"""
    try:
        data = request.json or {}
        user_message = data.get('message')
        user_id = data.get('user_id', 'default')  # ID unique par utilisateur
        conversation_id = data.get('conversation_id', 'default')  # ID de la conversation
        language = data.get('language')
        persona = data.get('persona')

        if not user_message:
            return jsonify({'error': 'Missing field: message'}), 400

        # Construire un identifiant de thread interne à partir de user + conversation
        thread_key = f"{user_id}:{conversation_id}"

        # Obtenir la réponse de l'agent en tenant compte éventuellement de la langue/persona
        response = agent.chat(
            user_message,
            thread_id=thread_key,
            language=language,
            persona=persona,
        )

        return jsonify({
            'response': response,
            'user_id': user_id,
            'conversation_id': conversation_id,
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/history', methods=['GET'])
def get_history():
    """Endpoint pour récupérer l'historique d'une conversation d'un utilisateur"""
    try:
        user_id = request.args.get('user_id', 'default')
        conversation_id = request.args.get('conversation_id', 'default')

        thread_key = f"{user_id}:{conversation_id}"
        history = agent.get_chat_history(thread_id=thread_key)

        return jsonify({
            'history': history,
            'user_id': user_id,
            'conversation_id': conversation_id,
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/clear_history', methods=['POST'])
def clear_history():
    """Endpoint pour réinitialiser l'historique d'une conversation d'un utilisateur"""
    try:
        data = request.json or {}
        user_id = data.get('user_id', 'default')
        conversation_id = data.get('conversation_id', 'default')

        thread_key = f"{user_id}:{conversation_id}"

        # Appeler la méthode de l'agent pour effacer l'historique
        agent.clear_history(thread_id=thread_key)

        return jsonify({
            'status': 'ok',
            'message': 'History cleared',
            'user_id': user_id,
            'conversation_id': conversation_id,
        }), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500



@app.route('/health', methods=['GET'])
def health():
    """Vérifier que l'API fonctionne"""
    return jsonify({'status': 'ok'})

if __name__ == '__main__':
    # écoute sur 0.0.0.0 pour rendre l'API accessible depuis le réseau local
    app.run(host='0.0.0.0', port=5000, debug=True)