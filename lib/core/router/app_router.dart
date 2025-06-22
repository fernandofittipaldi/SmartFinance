import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_finance/presentation/screens/add_goal.dart';
import 'package:smart_finance/presentation/screens/add_income_goal.dart';
import 'package:smart_finance/presentation/screens/add_movement_screen.dart';
import 'package:smart_finance/presentation/screens/balance_screen.dart';
import 'package:smart_finance/presentation/screens/crypto_rate_screen.dart';
import 'package:smart_finance/presentation/screens/currency_converter_screen.dart';
import 'package:smart_finance/presentation/screens/dollar_rate_screen.dart';
import 'package:smart_finance/presentation/screens/euro_rate_screen.dart';
import 'package:smart_finance/presentation/screens/general_balance_screen.dart';
import 'package:smart_finance/presentation/screens/goal_screen.dart';
import 'package:smart_finance/presentation/screens/investment_suggestions_screen.dart';
import 'package:smart_finance/presentation/screens/investments_screen.dart';
import 'package:smart_finance/presentation/screens/login_screen.dart';
import 'package:smart_finance/presentation/screens/price_screen.dart';
import 'package:smart_finance/presentation/screens/profile_screen.dart';
import 'package:smart_finance/presentation/screens/register_screen.dart';
import 'package:smart_finance/presentation/screens/risk_profile_screen.dart';

final GoRouter appRouter = GoRouter(
   redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isLogin = state.uri.toString() == '/login' || state.uri.toString() == '/register';

    if (!isLoggedIn && !isLogin) return '/login';
    if (isLoggedIn && isLogin) return '/balance';
    return null;
  },
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/balance', 
      builder: (context, state) => BalanceScreen(),
    ),
    GoRoute(
      path: '/add-income', 
      builder: (context, state) => AddMovementScreen(
        isIncome: true,
        title: 'Agregar Ingreso',
        categories: ['Salario', 'Otros'],
      ),
    ),
    GoRoute(
      path: '/add-expense', 
      builder: (context, state) => AddMovementScreen(
        isIncome: false,
        title: 'Agregar Egreso',
        categories: [
          'Comida',
          'Transporte',
          'Medicina',
          'Compras',
          'Hogar',
          'Regalos',
          'Ahorros',
          'Entretenimiento',
        ], 
      ),
    ),
    GoRoute(
      path: '/general-balance', 
      builder: (context, state) => GeneralBalanceScreen(),
    ),
    GoRoute(
      path: '/prices', 
      builder: (context, state) => PriceScreen(),
    ),
    GoRoute(
      path: '/goals', 
      builder: (context, state) => GoalScreen(),
    ),
    GoRoute(
      path: '/add-goal', 
      builder: (context, state) => AddGoalScreen(),
    ),
    GoRoute(
      path: '/add-income-goal/:goalId',
      builder: (context, state) {
        final goalId = state.pathParameters['goalId']!;
        return AddIncomeGoalScreen(goalId: goalId);
      },
    ),
    GoRoute(
      path: '/dollar-rates', 
      builder: (context, state) => const DollarRatesScreen(),
    ),
    GoRoute(
      path: '/euro-rates', 
      builder: (context, state) => const EuroRateScreen(),
    ),
    GoRoute(
      path: '/crypto-rates', 
      builder: (context, state) => const CryptoRateScreen(),
    ),
    GoRoute(
      path: '/currency-converter', 
      builder: (context, state) => const CurrencyConverterScreen(),
    ),
    GoRoute(
      path: '/investments', 
      builder: (context, state) => const InvestmentsScreen(),
    ),
    GoRoute(
      path: '/risk-profile', 
      builder: (context, state) => const RiskProfileScreen(),
    ),
    GoRoute(
      path: '/investment-suggestions', 
      builder: (context, state) => const InvestmentSuggestionsScreen(),
    ),
    GoRoute(
      path: '/login', 
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/profile', 
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);