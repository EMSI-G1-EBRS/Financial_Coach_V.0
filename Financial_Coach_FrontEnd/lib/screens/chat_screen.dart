import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final messages = chatProvider.messages;

    final isListening = chatProvider.isListening;
    final isReplying = chatProvider.isReplying;
    final selectedLang = localeProvider.chatLanguageCode;

    // Sync chat language with locale
    if (chatProvider.language != selectedLang) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        chatProvider.setLanguage(selectedLang);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial coach'),
        // Mettre un Builder ICI, pas autour du Scaffold
        leading: Builder(
          builder: (innerContext) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(innerContext).openDrawer(),
          ),
        ),
        actions: [
          // Bouton PROFIL
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Mon Profil',
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),

          // Bouton RESET de la conversation courante
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Réinitialiser cette conversation',
            onPressed: isReplying
                ? null
                : () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Réinitialiser ?'),
                  content: const Text(
                    'Tu vas effacer tous les messages de cette conversation. Continuer ?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Oui'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await context
                    .read<ChatProvider>()
                    .resetCurrentConversation();
              }
            },
          ),

          // Sélecteur de langue (FR / AR / EN)
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedLang,
                alignment: Alignment.centerRight,
                borderRadius: BorderRadius.circular(12),
                style: Theme.of(context).textTheme.bodyMedium,
                icon: const Icon(Icons.language, color: Colors.white),
                items: const [
                  DropdownMenuItem(
                    value: 'fr',
                    child: Text('🇫🇷 Expert (FR)', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                  ),
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text('🇲🇦 أخصائي (Darija)', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('🇺🇸 Expert (EN)', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                  ),
                ],
                onChanged: isReplying
                    ? null
                    : (val) {
                  if (val == null) return;
                  context.read<ChatProvider>().setLanguage(val);
                },
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 120, top: 8),
            itemCount: messages.length,
            itemBuilder: (context, index) =>
                ChatBubble(message: messages[index]),
          ),
          if (isReplying)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Le coach réfléchit...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          final isListening = chatProvider.isListening;
          final isReplying = chatProvider.isReplying;
        

          return FloatingActionButton(
            backgroundColor: isListening ? Colors.red : const Color.fromARGB(255, 3, 63, 130),
            onPressed: isReplying
                ? null
                : () {
              if (isListening) {
                // permettre d’arrêter manuellement
                chatProvider.stopListeningAndSend();
              } else {
                chatProvider.startListening();
              }
            },
            child: Icon(isListening ? Icons.mic_off : Icons.mic),
          );
        },
      ),
    );
  }
}
