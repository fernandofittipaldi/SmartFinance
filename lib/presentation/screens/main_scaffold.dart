import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_finance/presentation/providers/app_user_provider.dart';
import 'package:smart_finance/presentation/providers/auth_controller.dart';
import 'package:smart_finance/presentation/providers/movement_provider.dart';

class MainScaffold extends ConsumerWidget {
  final Widget body;
  final int currentIndex;

  const MainScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/balance');
        break;
      case 1:
        context.go('/general-balance');
        break;
      case 2:
        context.go('/goals');
        break;
      case 3:
        context.go('/investments');
        break;
      case 4:
        context.go('/prices');
        break;
      case 5:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(appUserProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Smart Finance'),
            const Spacer(),
            if (appUser != null) Text('${appUser.name} ${appUser.lastName}'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              final confirmLogout = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Cerrar Sesión'),
                    content: const Text(
                      '¿Está seguro que desea cerrar sesión?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Sí'),
                      ),
                    ],
                  );
                },
              );
              if (confirmLogout == true) {
                ref.read(movementProvider.notifier).clear();
                ref.read(authControllerProvider.notifier).signOut(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sesión cerrada correctamente')),
                );
              }
            },
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: 'Saldo'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'General',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet), 
            label: 'Metas'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Inversiones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Cotizaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), 
            label: 'Perfil'
          ),
        ],
      ),
    );
  }
}
