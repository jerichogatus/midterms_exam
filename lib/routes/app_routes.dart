import 'package:app/screens/cart/cart_screen.dart';
import 'package:app/screens/common/splash_screens.dart';
import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/common/role_selection.dart';
import '../screens/user/user_home.dart';
import '../screens/admin/admin_home.dart';
import '../screens/admin/manage_tickets.dart';
import '../screens/common/about_us.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String roleSelection = '/role_selection';
  static const String userHome = '/user_home';
  static const String adminHome = '/admin_home';
  static const String manageTickets = '/manage_tickets';
  static const String aboutUs = '/about_us';
  static const String cartScreen = '/cart_screen';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => LoginScreen(),  
      signup: (context) => SignupScreen(),
      roleSelection: (context) => const RoleSelectionScreen(),
      userHome: (context) => const UserHomeScreen(),
      adminHome: (context) => const AdminHomeScreen(),
      manageTickets: (context) => const ManageTicketsScreen(),
      aboutUs: (context) => const AboutUsScreen(),
      cartScreen: (context) => const CartScreen(),
    };
  }
}