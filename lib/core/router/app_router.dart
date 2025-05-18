import 'package:go_router/go_router.dart';
import 'package:smart_finance/presentation/screens/add_expense_screen.dart';
import 'package:smart_finance/presentation/screens/add_income_screen.dart';
import 'package:smart_finance/presentation/screens/balance_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/balance',
  routes: [
    GoRoute(
      path: '/balance', 
      builder: (context, state) => BalanceScreen(),
    ),
    GoRoute(
      path: '/add_income', 
      builder: (context, state) => AddIncomeScreen(),
    ),  
    GoRoute(
      path: '/add_expense', 
      builder: (context, state) => AddExpenseScreen(),
    ),
  ],
);