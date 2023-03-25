import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_budget_app/provider/user_provider.dart';
import 'package:new_budget_app/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/recurring_expenses_screen.dart';
import 'screens/monthly_overview_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: Consumer<UserProvider>(
        builder: (_, userProvider, __ ){return GetMaterialApp(
          title: 'Budget App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: userProvider.user == null  ? '/login' : '/home',
          getPages: [
            GetPage(name: '/login', page: () => LoginPage()),
            GetPage(name: '/', page: () => HomeScreen()),
            GetPage(name: '/categories', page: () => CategoriesScreen()),
            GetPage(name: '/recurring_expenses', page: () => RecurringExpensesScreen()),
            GetPage(name: '/monthly_overview', page: () => OverviewScreen()),
          ],
        );}
      ),
    );
  }
}
