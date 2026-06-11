import 'package:angel_messages/models/message.dart';
import 'package:angel_messages/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    required this.message,
    super.key,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Hero(
      tag: 'message-${message.id}',
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          onTap: () {
            context.push('/message/${message.id}');
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: message.viewed
                    ? Colors.transparent
                    : AppTheme.softGold.withOpacity(0.5),
                width: 2,
              ),
              gradient: message.viewed
                  ? null
                  : LinearGradient(
                      colors: [
                        AppTheme.softGold.withOpacity(0.1),
                        Colors.transparent,
                        AppTheme.softGold.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message.title,
                          style: textTheme.titleLarge?.copyWith(
                            color: message.viewed
                                ? theme.colorScheme.onSurface
                                : AppTheme.softGold,
                          ),
                        ),
                      ),
                      if (!message.viewed)
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
                  const Gap(8),
                  Text(
                    message.body.length > 120
                        ? '${message.body.substring(0, 120)}...'
                        : message.body,
                    style: textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message.category.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: AppTheme.mutedLavender,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
