import 'package:go_router/go_router.dart';
import 'package:smart_finance/presentation/screens/add_expense_screen.dart';
import 'package:smart_finance/presentation/screens/add_income_screen.dart';
import 'package:smart_finance/presentation/screens/balance_screen.dart';

final GoRouter appRouter = GoRouter(
  initialExtra: '/balance',
  routes: [
    GoRoute(
      path: '/balance', 
      builder: (context, state) => const BalanceScreen(),
    ),
    GoRoute(
      path: '/add_income', 
      builder: (context, state) => const AddIncomeScreen(),
    ),  
    GoRoute(
      path: '/add_expense', 
      builder: (context, state) => const AddExpenseScreen(),
    ),
  ],
);