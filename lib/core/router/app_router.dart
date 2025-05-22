import 'package:go_router/go_router.dart';
import 'package:smart_finance/presentation/screens/add_expense_screen.dart';
import 'package:smart_finance/presentation/screens/add_income_screen.dart';
import 'package:smart_finance/presentation/screens/balance_screen.dart';
import 'package:smart_finance/presentation/screens/general_balance_screen.dart';
import 'package:smart_finance/presentation/screens/goal_screen.dart';
import 'package:smart_finance/presentation/screens/price_screen.dart';

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
    GoRoute(
      path: '/general-balance', 
      builder: (context, state) =>GeneralBalanceScreen(),
    ),
    GoRoute(
      path: '/prices', 
      builder: (context, state) => PriceScreen(),
    ),
    GoRoute(
      path: '/goals', 
      builder: (context, state) => GoalScreen(),
    )
  ],
);