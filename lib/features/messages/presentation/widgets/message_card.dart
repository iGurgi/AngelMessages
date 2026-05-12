import 'package:angel_messages/core/routing/app_router.dart';
import 'package:angel_messages/core/theme/app_theme.dart';
import 'package:angel_messages/features/messages/data/models/message.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Card widget for displaying a message in the list
class MessageCard extends StatelessWidget {
  const MessageCard({
    required this.message,
    super.key,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnviewed = !message.viewed;

    return Card(
      elevation: isUnviewed ? 4 : 2,
      child: InkWell(
        onTap: () => AppRouter.navigateToMessage(context, message.id),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isUnviewed
                ? Border.all(
                    color: AppTheme.softGold.withOpacity(0.5),
                    width: 2,
                  )
                : null,
            gradient: isUnviewed
                ? LinearGradient(
                    colors: [
                      AppTheme.softGold.withOpacity(0.1),
                      Colors.transparent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  message.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: isUnviewed ? AppTheme.softGold : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(8),
                // Body preview
                Text(
                  message.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(12),
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.mutedLavender.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message.category.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.mutedLavender,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Unviewed indicator
                    if (isUnviewed)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.softGold,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.softGold.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
