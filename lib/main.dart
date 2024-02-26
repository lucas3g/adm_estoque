import 'package:adm_estoque/app/app_widget.dart';
import 'package:adm_estoque/app/di/dependency_injection.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(const AppWidget());
}
