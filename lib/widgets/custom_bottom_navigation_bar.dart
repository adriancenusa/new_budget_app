import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/home_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/recurring_expenses_screen.dart';
import '../screens/monthly_overview_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  CustomBottomNavigationBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
        BottomNavigationBarItem(icon: Icon(Icons.repeat), label: 'Recurring'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Overview'),
      ],
      onTap: (index) {
        if (currentIndex != index) {
          Widget targetScreen;

          switch (index) {
            case 0:
              targetScreen = HomeScreen();
              break;
            case 1:
              targetScreen = CategoriesScreen();
              break;
            case 2:
              targetScreen = RecurringExpensesScreen();
              break;
            case 3:
              targetScreen = OverviewScreen();
              break;
            default:
              throw Exception('Invalid index for navigation');
          }

          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => targetScreen,
              transitionDuration: Duration(milliseconds: 300),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        }
      },
    );
  }
}
