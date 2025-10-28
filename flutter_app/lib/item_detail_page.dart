import 'package:flutter/material.dart';
import 'package:rebot_flutter_app/api.dart';
import 'package:rebot_flutter_app/models/comment.dart';
import 'package:rebot_flutter_app/models/item.dart';
import 'package:rebot_flutter_app/models/user.dart';

class ItemDetailPage extends StatefulWidget {
  final int itemId;
  final String itemTitle;

  const ItemDetailPage({
    super.key,
    required this.itemId,
    required this.itemTitle,
  });

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  late Future<Item> itemDetailsFuture;
  late Future<List<Comment>> commentsFuture;
  late Future<List<User>> usersFuture;
  final TextEditingController _commentController = TextEditingController();
  bool _isPostingComment = false;

  @override
  void initState() {
    super.initState();
    itemDetailsFuture = fetchItemDetails(widget.itemId);
    commentsFuture = fetchItemComments(widget.itemId);
    usersFuture = fetchUsers();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handlePostComment() async {
    if (_commentController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isPostingComment = true;
    });

    try {
      // NOTE: In a real app, you would get the current user's ID and token
      // from your authentication state management solution.
      // For this test, we are hardcoding the user ID and a mock token.
      await postComment(
        itemId: widget.itemId,
        userId: 2, // Hardcoded user ID for demonstration
        content: _commentController.text,
        token: 'mock-jwt-token', // Hardcoded token for demonstration
      );

      // --- New Optimistic Update Logic ---
      // Since the mock backend doesn't persist the new comment,
      // we will manually add it to the list on the frontend for a good UX.
      final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch, // A temporary unique ID
        itemId: widget.itemId,
        userId: 2,
        content: _commentController.text,
        createdAt: DateTime.now().toIso8601String(),
      );

      // Update the UI by adding the new comment to the existing future
      final currentComments = await commentsFuture;
      setState(() {
        commentsFuture = Future.value(currentComments..add(newComment));
      });
      // --- End of New Logic ---

      // Clear the text field
      _commentController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to post comment: $e')));
      }
    } finally {
      setState(() {
        _isPostingComment = false;
      });
    }
  }

  String _getUserInitials(User user) {
    final firstName = user.firstName ?? '';
    final lastName = user.lastName ?? '';
    return '${firstName.isNotEmpty ? firstName[0].toUpperCase() : ''}'
        '${lastName.isNotEmpty ? lastName[0].toUpperCase() : ''}';
  }

  String _getUserName(User user) =>
      '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.itemTitle)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<List<Object>>(
            future: Future.wait([itemDetailsFuture, usersFuture]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error loading item: ${snapshot.error}'),
                );
              } else {
                final item = snapshot.data![0] as Item;
                final users = snapshot.data![1] as List<User>;

                final userMap = {for (var u in users) u.id: u};

                final creator = userMap[item.createdBy];
                final creatorName = creator != null
                    ? _getUserName(creator)
                    : 'Unknown User';

                return Card(
                  margin: const EdgeInsets.all(16.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        Text(
                          'Created by $creatorName',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          'Created: ${_formatDate(item.createdAt)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (item.updatedAt != null)
                          Text(
                            'Updated: ${_formatDate(item.updatedAt!)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Text(
              'Comments',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Object>>(
              future: Future.wait([commentsFuture, usersFuture]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Comments',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Comments',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Error loading comments: ${snapshot.error}',
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  final List<Comment> comments =
                      snapshot.data![0] as List<Comment>;
                  final List<User> users = snapshot.data![1] as List<User>;

                  final userMap = {for (var u in users) u.id: u};

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Comments (${comments.length})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: comments.isEmpty
                            ? const Center(
                                child: Text('No comments found for this item.'),
                              )
                            : Builder(
                                builder: (context) {
                                  final sortedComments =
                                      List<Comment>.from(comments)..sort(
                                        (a, b) => DateTime.parse(b.createdAt)
                                            .compareTo(
                                              DateTime.parse(a.createdAt),
                                            ),
                                      );

                                  return ListView.builder(
                                    padding: const EdgeInsets.all(16.0),
                                    itemCount: sortedComments.length,
                                    itemBuilder: (context, index) {
                                      final comment = sortedComments[index];
                                      final user = userMap[comment.userId];
                                      final userInitials = user != null
                                          ? _getUserInitials(user)
                                          : 'U';
                                      final userName = user != null
                                          ? _getUserName(user)
                                          : 'Unknown User';

                                      return Card(
                                        elevation: 2.0,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                          vertical: 8.0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Theme.of(
                                              context,
                                            ).colorScheme.primaryContainer,
                                            child: Text(
                                              userInitials,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            userName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(comment.content),
                                              const SizedBox(height: 4),
                                              Text(
                                                _formatDate(comment.createdAt),
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          _buildCommentInputField(),
        ],
      ),
    );
  }

  Widget _buildCommentInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _handlePostComment(),
            ),
          ),
          _isPostingComment
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _handlePostComment,
                ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      final month = months[date.month - 1];
      final day = date.day;
      final year = date.year;

      final hour = date.hour == 0
          ? 12
          : (date.hour > 12 ? date.hour - 12 : date.hour);
      final minute = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'PM' : 'AM';

      return '$day $month $year $hour:$minute$period';
    } catch (e) {
      return dateString;
    }
  }
}
