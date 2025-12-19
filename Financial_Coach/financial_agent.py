import os
import uuid
from typing import Optional
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage, AIMessage
from langgraph.checkpoint.memory import MemorySaver
from langgraph.graph import StateGraph, START, MessagesState

# Charger les variables d'environnement (le fichier .env)
load_dotenv()


class FinancialCoachAgent:
    def __init__(self):
        """Initialise l'agent coach financier avec mémoire"""

        # 1. Initialiser le LLM avec OpenRouter (Llama 3.3 GRATUIT)
        self.llm = ChatOpenAI(
            model="google/gemma-3-27b-it:free",
            openai_api_key=os.getenv("OPENROUTER_API_KEY"),
            openai_api_base="https://openrouter.ai/api/v1",
            temperature=0.7,  # Créativité modérée
            max_tokens=1000  # Limite de tokens par réponse
        )

        # 2. Définir un prompt système par défaut (sera surchargé dynamiquement)
        self.system_prompt = self.get_system_prompt(language="fr", persona="expert_comptable")

        # 3. Créer le système de mémoire (sauvegarde les conversations)
        self.memory = MemorySaver()

        self.user_threads = {}

        # 4. Construire le graphe conversationnel
        self.app = self._build_graph()

    def _build_graph(self):
        """Construit le graphe LangGraph avec mémoire"""

        def call_model(state: MessagesState):
            # Ajouter le prompt système au début
            messages = [SystemMessage(content=self.system_prompt)] + state["messages"]
            response = self.llm.invoke(messages)
            return {"messages": [response]}

        # Créer le graphe
        builder = StateGraph(MessagesState)
        builder.add_node("model", call_model)
        builder.add_edge(START, "model")

        # Compiler avec la mémoire
        return builder.compile(checkpointer=self.memory)

    def _get_internal_thread_id(self, external_id: str) -> str:
        """
        Mappe un identifiant utilisateur (user_id) vers un identifiant interne
        utilisé par LangGraph pour le thread.

        Cela nous permet de 'réinitialiser' une conversation en changeant
        simplement de thread interne.
        """
        external_id = external_id or "default"

        # Si aucun thread interne n'existe encore pour cet utilisateur,
        # on en crée un nouveau.
        if external_id not in self.user_threads:
            self.user_threads[external_id] = f"{external_id}-{uuid.uuid4().hex}"

        return self.user_threads[external_id]


    def get_system_prompt(self, language: str = "fr", persona: Optional[str] = None) -> str:
        """
        Retourne un prompt adapté à la langue/persona, en forçant la langue de sortie.
        Priorité: persona explicite > mapping par langue. Defaults to FR coach financier.
        Pensé pour un assistant VOCAL : réponses courtes, claires, faciles à lire à voix haute.
        """
        lang = (language or "fr").lower()
        per = (persona or "").lower()

        # Normaliser raccourcis de langue
        valid_langs = {"fr", "ar", "en"}
        if lang not in valid_langs:
            lang = "fr"

        # Persona par défaut si rien n'est fourni
        default_persona_by_lang = {
            "fr": "expert_comptable",
            "ar": "grand_frere_darija",
            "en": "wall_street_trader",
        }
        if not per:
            per = default_persona_by_lang.get(lang, "coach financier")

        # ====== AR / DARIJA ======
        if per == "كوتش مالي" or lang == "ar":
            return (
                "انتَ كوتش مالي شخصي، خبير وكتعاون المستخدم بطريقة واضحة وبالدارجة المغربية.\n"
                "الدور ديالك هو تعاون المستخدم باش يفهم الفلوس ديالو، يدير ميزانية، "
                "يوفّر مزيان، ينقص الديون، ويخطط لأهداف مالية مناسبة لوضعيتو.\n\n"
                "قواعد مهمة:\n"
                "- سول بزاف باش تفهم الوضعية المالية ديالو مزيان (مدخول، مصاريف، ديون، أهداف...)\n"
                "- أعطِ نصائح عملية وقابلة للتطبيق فالحياة اليومية\n"
                "- استعمل لغة بسيطة، مفهومة، وبعيدة على المصطلحات الصعبة\n"
                "- كون مشجع، ما تحكمش عليه، وعاونُو خطوة بخطوة\n"
                "- ما تعطيش أبداً أسماء أسهم أو كريبتو معينة للاستثمار\n"
                "- ذكّر دائماً بلي ماشي مستشار مالي معتمد، غير كوتش إرشادي\n\n"
                "أسلوب خاص بالمساعد الصوتي:\n"
                "- جاوب بجمل قصيرة وواضحة، ما بين 3 و5 جمل فالغالب\n"
                "- تجنب الفقرات الطويلة بزاف أو القوائم الكبيرة\n"
                "- إلا كان مناسب، سالِ الجواب بسؤال بسيط باش تكملو الهضرة\n"
                "- جاوب دائماً بالدارجة أو عربية مبسطة، ماشي بالفرنسية أو الإنجليزية.\n"
            )

        # ====== ENGLISH ======
        if per == "financial coach" or lang == "en":
            return (
                "You are a personal financial coach: kind, supportive, and knowledgeable.\n"
                "Your role is to help the user:\n"
                "- Understand their personal finances\n"
                "- Build and follow a realistic budget\n"
                "- Save money effectively\n"
                "- Reduce and manage debt\n"
                "- Plan for their financial goals over time\n\n"
                "Rules:\n"
                "- Ask questions first to understand their situation (income, expenses, debts, goals...)\n"
                "- Give practical, realistic advice they can apply in daily life\n"
                "- Use clear, simple language without technical jargon\n"
                "- Be encouraging and non-judgmental\n"
                "- Never give specific stock or crypto recommendations\n"
                "- Always remind them that you are not a certified financial advisor\n\n"
                "Voice assistant style:\n"
                "- Keep answers concise: usually 3 to 5 short sentences\n"
                "- Prefer spoken, conversational language rather than long written paragraphs\n"
                "- Avoid long lists; when needed, give at most 3 or 4 simple steps\n"
                "- When appropriate, end with one short follow-up question to keep the conversation going\n"
                "Always respond in English."
            )

        # ====== FRANÇAIS (par défaut) ======
        return (
            "Tu es un coach financier personnel, bienveillant et expert.\n"
            "Ton rôle est d'aider l'utilisateur à :\n"
            "- Comprendre ses finances personnelles\n"
            "- Établir et suivre un budget réaliste\n"
            "- Épargner efficacement\n"
            "- Réduire et gérer ses dettes\n"
            "- Atteindre ses objectifs financiers dans le temps\n\n"
            "Règles :\n"
            "- Commence par poser des questions pour bien comprendre sa situation "
            "(revenus, dépenses, dettes, objectifs...)\n"
            "- Donne des conseils concrets, actionnables et adaptés à sa réalité\n"
            "- Utilise un langage simple, sans jargon technique\n"
            "- Reste encourageant, jamais dans le jugement\n"
            "- Ne donne jamais de recommandations précises d'actions ou de crypto\n"
            "- Rappelle régulièrement que tu n'es pas un conseiller financier certifié\n\n"
            "Style spécial assistant vocal :\n"
            "- Réponds avec des phrases courtes, faciles à lire à voix haute "
            "(en général 3 à 5 phrases maximum)\n"
            "- Évite les gros pavés de texte ; si besoin, propose 3 ou 4 étapes simples\n"
            "- Quand c'est utile, termine par une petite question pour continuer la discussion\n"
            "- Réponds toujours en français."
        )

    def update_system_prompt(self, language: Optional[str] = None, persona: Optional[str] = None) -> None:
        """Met à jour le prompt système courant en fonction de la langue/persona."""
        self.system_prompt = self.get_system_prompt(language=language or "fr", persona=persona)

    def chat(self, user_message: str, thread_id: str = "default",
             language: Optional[str] = None, persona: Optional[str] = None) -> str:
        """
        Envoie un message à l'agent et retourne sa réponse.
        `thread_id` correspond à l'identité externe (user_id).
        """

        # Mettre à jour le prompt si des préférences sont fournies
        if language or persona:
            self.update_system_prompt(language=language, persona=persona)

        # Convertir le thread externe (user_id) en thread interne LangGraph
        external_id = thread_id or "default"
        internal_thread_id = self._get_internal_thread_id(external_id)

        # Configuration pour identifier la conversation dans LangGraph
        config = {"configurable": {"thread_id": internal_thread_id}}

        # Invoquer l'agent avec le message
        input_messages = [HumanMessage(content=user_message)]

        try:
            result = self.app.invoke({"messages": input_messages}, config)
            # Extraire la réponse
            return result["messages"][-1].content
        except Exception as e:
            return f"Erreur lors de la communication avec le modèle : {e}"

    def get_chat_history(self, thread_id: str = "default") -> list:
        """
        Récupère l'historique complet d'une conversation pour un utilisateur.
        """
        external_id = thread_id or "default"
        internal_thread_id = self._get_internal_thread_id(external_id)
        config = {"configurable": {"thread_id": internal_thread_id}}

        # Si aucun état n'existe encore pour ce thread, on retourne une liste vide
        try:
            state = self.app.get_state(config)
        except Exception:
            return []

        history = []
        for msg in state.values.get("messages", []):
            if isinstance(msg, HumanMessage):
                history.append({"role": "user", "content": msg.content})
            elif isinstance(msg, AIMessage):
                history.append({"role": "assistant", "content": msg.content})
        return history

    def clear_history(self, thread_id: str = "default") -> None:
        """
        Efface l'historique d'une conversation pour un utilisateur.

        Techniquement, on assigne un nouveau thread interne à ce user_id.
        L'ancien état reste stocké dans le checkpointer, mais il n'est plus utilisé.
        """
        user_id = thread_id or "default"
        self.user_threads[user_id] = f"{user_id}-{uuid.uuid4().hex}"
        print(f"[clear_history] Nouveau thread créé pour user_id={user_id}")


# Test rapide (sera exécuté si on lance ce fichier directement)
if __name__ == "__main__":
    print("🏦 Initialisation du Coach Financier avec OpenRouter (Llama 3.3)...")
    print("=" * 60)

    agent = FinancialCoachAgent()

    # Test 1: Premier message
    print("\n👤 Utilisateur: Bonjour, je gagne 2000€ par mois et je dépense tout. Comment commencer à épargner?")
    response1 = agent.chat("Bonjour, je gagne 2000€ par mois et je dépense tout. Comment commencer à épargner?")
    print(f"\n🤖 Coach: {response1}")

    # Test 2: Message de suivi (avec mémoire)
    print("\n" + "=" * 60)
    print("\n👤 Utilisateur: J'ai déjà essayé mais j'abandonne toujours après 2 semaines")
    response2 = agent.chat("J'ai déjà essayé mais j'abandonne toujours après 2 semaines")
    print(f"\n🤖 Coach: {response2}")

    # Test 3: Test en Arabe
    print("\n" + "=" * 60)
    print("\n👤 Utilisateur: مرحبا، كيف يمكنني البدء في التوفير؟")
    response3 = agent.chat("مرحبا، كيف يمكنني البدء في التوفير؟")
    print(f"\n🤖 Coach: {response3}")

    # Afficher l'historique
    print("\n" + "=" * 60)
    print("\n📜 Historique de la conversation:")
    history = agent.get_chat_history()
    for i, msg in enumerate(history, 1):
        role = "👤 Utilisateur" if msg["role"] == "user" else "🤖 Coach"
        print(f"\n{i}. {role}: {msg['content'][:100]}...")