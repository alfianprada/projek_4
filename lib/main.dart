// lib/main.dart
import 'package:flutter/material.dart';
import 'package:projek_4/list_page.dart';
import 'package:projek_4/pages/form_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://mwlrwjaxpswmraqjbfnx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im13bHJ3amF4cHN3bXJhcWpiZm54Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5Nzg4NTAsImV4cCI6MjA3MzU1NDg1MH0.DKDA9nzMpniqNWxzCfR3q6nP2Y1d_fLNLe-aprtKe6g',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Siswa',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
