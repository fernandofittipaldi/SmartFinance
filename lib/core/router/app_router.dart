import 'package:go_router/go_router.dart';
import 'package:smart_finance/presentation/screens/add_expense_screen.dart';
import 'package:smart_finance/presentation/screens/add_income_screen.dart';
import 'package:smart_finance/presentation/screens/balance_screen.dart';
import 'package:smart_finance/presentation/screens/crypto_rate_screen.dart';
import 'package:smart_finance/presentation/screens/currency_converter_screen.dart';
import 'package:smart_finance/presentation/screens/dollar_rate_screen.dart';
import 'package:smart_finance/presentation/screens/euro_rate_screen.dart';
import 'package:smart_finance/presentation/screens/general_balance_screen.dart';
import 'package:smart_finance/presentation/screens/goal_screen.dart';
import 'package:smart_finance/presentation/screens/investment_suggestions_screen.dart';
import 'package:smart_finance/presentation/screens/investments_screen.dart';
import 'package:smart_finance/presentation/screens/price_screen.dart';
import 'package:smart_finance/presentation/screens/risk_profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
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
  ],
);