import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tealvue_project/providers/theme_providers.dart';
import 'providers/portfolio_provider.dart';
import 'screens/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GreenPortfolioApp());
}

class GreenPortfolioApp extends StatelessWidget {
  const GreenPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..init()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Green Portfolio Tracker',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.theme,
            home: const DashboardScreen(),
          );
        },
      ),
    );
  }
}
