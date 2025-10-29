import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rebot_flutter_app/screens/login/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rebot_flutter_app/widgets/LoginButton.dart';
import 'package:rebot_flutter_app/api.dart';
import 'package:rebot_flutter_app/bloc/login_bloc.dart';
import 'package:rebot_flutter_app/bloc/login_event.dart';
import 'package:rebot_flutter_app/bloc/login_state.dart';
import 'package:rebot_flutter_app/env_selector.dart';
import 'package:rebot_flutter_app/models/office.dart';
import 'package:rebot_flutter_app/office_detail_page.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: getEnvFile());
  } catch (e) {
    debugPrint('Warning: Failed to load .env file: $e');
  }

  runApp(RebotApp());
}

class RebotApp extends StatelessWidget {
  const RebotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc()..add(LoginWithRememberMe()),
      child: MaterialApp(
        title: 'Rebot Offices',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const OfficeListPage(),
      ),
    );
  }
}

class OfficeListPage extends StatefulWidget {
  const OfficeListPage({super.key});

  @override
  State<OfficeListPage> createState() => _OfficeListPageState();
}

class _OfficeListPageState extends State<OfficeListPage> {
  late Future<List<Office>> officesFuture;

  @override
  void initState() {
    super.initState();
    officesFuture = fetchOffices();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(milliseconds: 500),
              content: Text(state.errorMessage!),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: state.isSuccess
              ? LoginButton(
                  onPressed: () {
                    context.read<LoginBloc>().add(Logout());
                  },
                  text: "Logout",
                )
              : null,
          appBar: AppBar(
            title: const Text(
              'Offices',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFF0055A4), // Barry Plant Blue
            elevation: 4.0,
          ),
          body: state.isSuccess
              ? FutureBuilder<List<Office>>(
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
                          return Card(
                            elevation: 4.0,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16.0),
                              title: Text(
                                office.name,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                office.address,
                                style: const TextStyle(
                                  color: Color(0xFF0055A4), // Barry Plant Blue
                                ),
                              ),
                              trailing: Text(
                                '${office.settings.maxItemsPerUser} items',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OfficeDetailPage(
                                      officeId: office.id,
                                      officeName: office.name,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                )
              : Login(),
        );
      },
    );
  }
}
