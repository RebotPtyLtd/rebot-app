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

  runApp(
    RebotApp(),
  );
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
      ));
}}

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
   return  BlocConsumer<LoginBloc,LoginState>(
      listener: (context, state) {
          if (state.errorMessage != null) { ScaffoldMessenger.of( context, ).showSnackBar(SnackBar(duration: Duration(milliseconds: 500),content: Text(state.errorMessage!))); }
      },
     builder: (context,state){
       return Scaffold(
         floatingActionButton:state.isSuccess? LoginButton(onPressed: (){
           context.read<LoginBloc>().add(Logout());
         },text: "Logout"):null,
         appBar: AppBar(title: const Text('Offices'),),
         body:state.isSuccess? FutureBuilder<List<Office>>(
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
                     title: Text(office.name),
                     subtitle: Text(office.address),
                     trailing: Text(
                       '${office.settings.maxItemsPerUser} items',
                       style: const TextStyle(fontSize: 12),
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
                   );
                 },
               );
             }
           },
         ):Login(),
       );
     },
   );



  }
}
