import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'env_selector.dart';
import 'api.dart';
import 'office_detail_page.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: getEnvFile());
  } catch (e) {
    debugPrint("Warning: Failed to load .env file: $e");
  }

  runApp(const RebotApp());
}

class RebotApp extends StatelessWidget {
  const RebotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rebot Offices',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const OfficeListPage(),
    );
  }
}

class OfficeListPage extends StatefulWidget {
  const OfficeListPage({super.key});

  @override
  State<OfficeListPage> createState() => _OfficeListPageState();
}

class _OfficeListPageState extends State<OfficeListPage> {
  late Future<List<dynamic>> officesFuture;

  @override
  void initState() {
    super.initState();
    officesFuture = fetchOffices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offices')),
      body: FutureBuilder<List<dynamic>>(
        future: officesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final offices = snapshot.data!;
            return ListView.builder(
              itemCount: offices.length,
              itemBuilder: (context, index) {
                final office = offices[index];
                return ListTile(
                  title: Text(office['name']),
                  subtitle: Text(office['address']),
                  trailing: Text(
                    '${office['settings']['maxItemsPerUser']} items',
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OfficeDetailPage(
                          officeId: office['id'],
                          officeName: office['name'],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
