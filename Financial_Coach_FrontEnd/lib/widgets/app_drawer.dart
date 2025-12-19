import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/user_profile_provider.dart';
import 'theme_switch_button.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Consumer<ChatProvider>(
          builder: (context, chatProvider, _) {
            final ids = chatProvider.conversationIds;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Conversations',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const ThemeSwitchButton(isIconOnly: true),
                    ],
                  ),
                ),

                // Carte de profil
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Consumer<UserProfileProvider>(
                    builder: (context, profileProvider, _) {
                      final profile = profileProvider.profile;
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Icon(
                              profile != null ? Icons.person : Icons.person_outline,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            profile?.fullName ?? 'Mon Profil',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            profile != null
                                ? '${profileProvider.getProfileSummary()['completeness']}% complet'
                                : 'Configurer mon profil',
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.of(context).pushNamed('/profile');
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      chatProvider.newConversation();
                      Navigator.of(context).maybePop();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Nouvelle Conversation'),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ids.isEmpty
                      ? const Center(
                          child: Text('Aucune conversation enregistrée'),
                        )
                      : ListView.separated(
                          itemCount: ids.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final id = ids[index];
                            final isCurrent = id == chatProvider.currentConversationId;
                            return ListTile(
                              title: Text(
                                id,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isCurrent ? Theme.of(context).colorScheme.primary : null,
                                ),
                              ),
                              onTap: () async {
                                await chatProvider.switchConversation(id);
                                if (context.mounted) {
                                    Navigator.of(context).maybePop();
                                }
                              },
                            );
                          },
                        ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
