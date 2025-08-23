import 'package:flutter/material.dart';
import 'package:rebot_flutter_app/api.dart';
import 'package:rebot_flutter_app/models/item.dart';
import 'package:rebot_flutter_app/models/comment.dart';
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

  @override
  void initState() {
    super.initState();
    itemDetailsFuture = fetchItemDetails(widget.itemId);
    commentsFuture = fetchItemComments(widget.itemId);
    usersFuture = fetchUsers();
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
        children: [
          FutureBuilder<List<Object>>(
            future: Future.wait([itemDetailsFuture, usersFuture]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
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

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Created by $creatorName',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Created: ${_formatDate(item.createdAt)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      if (item.updatedAt != null)
                        Text(
                          'Updated: ${_formatDate(item.updatedAt!)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                );
              }
            },
          ),
          // Comments Section
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
                                        elevation: 0.0,
                                        margin: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 16,
                                                    backgroundColor:
                                                        Colors.blue.shade100,
                                                    child: Text(
                                                      userInitials,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    userName,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    _formatDate(
                                                      comment.createdAt,
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(comment.content),
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
