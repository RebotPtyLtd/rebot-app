import 'package:flutter/material.dart';
import 'package:rebot_flutter_app/models/item.dart';
import 'package:rebot_flutter_app/api.dart';
import 'package:rebot_flutter_app/item_detail_page.dart';
import 'package:rebot_flutter_app/models/office.dart';

class OfficeDetailPage extends StatefulWidget {
  final int officeId;
  final String officeName;

  const OfficeDetailPage({
    super.key,
    required this.officeId,
    required this.officeName,
  });

  @override
  State<OfficeDetailPage> createState() => _OfficeDetailPageState();
}

class _OfficeDetailPageState extends State<OfficeDetailPage> {
  late Future<Office> officeDetailsFuture;
  late Future<List<Item>> itemsFuture;
  @override
  void initState() {
    super.initState();
    officeDetailsFuture = _getOfficeFromList();
    itemsFuture = fetchOfficeItems(widget.officeId);
  }

  Future<Office> _getOfficeFromList() async {
    final offices = await fetchOffices();
    return offices.firstWhere(
      (o) => o.id == widget.officeId,
      orElse: () => throw Exception('Office not found'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.officeName)),
      body: Column(
        children: [
          // Office Details Section
          FutureBuilder<Office>(
            future: officeDetailsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error loading office details: ${snapshot.error}',
                  ),
                );
              } else {
                final office = snapshot.data!;
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        office.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        office.address,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Max items per user: ${office.settings.maxItemsPerUser}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Timezone: ${office.settings.timezone}',
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
          // Items Section
          Expanded(
            child: FutureBuilder<List<Item>>(
              future: itemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Items',
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
                            'Items',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text('Error loading items: ${snapshot.error}'),
                        ),
                      ),
                    ],
                  );
                } else {
                  final List<Item> items = snapshot.data!;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Items (${items.length})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: items.isEmpty
                            ? const Center(
                                child: Text('No items found for this office.'),
                              )
                            : Builder(
                                builder: (context) {
                                  final sortedItems = List<Item>.from(items);
                                  sortedItems.sort((a, b) {
                                    try {
                                      final dateA = DateTime.parse(a.createdAt);
                                      final dateB = DateTime.parse(b.createdAt);
                                      return dateB.compareTo(dateA);
                                    } catch (e) {
                                      return 0;
                                    }
                                  });

                                  return ListView.builder(
                                    padding: const EdgeInsets.all(16.0),
                                    itemCount: sortedItems.length,
                                    itemBuilder: (context, index) {
                                      final item = sortedItems[index];
                                      return Card(
                                        elevation: 0.0,
                                        margin: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
                                        child: ListTile(
                                          title: Text(item.title),
                                          subtitle: Text(
                                            item.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ItemDetailPage(
                                                      itemId: item.id,
                                                      itemTitle: item.title,
                                                    ),
                                              ),
                                            );
                                          },
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
}
