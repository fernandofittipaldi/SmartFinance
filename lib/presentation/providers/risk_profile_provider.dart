import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_finance/presentation/providers/app_user_provider.dart';
import 'package:smart_finance/domain/app_user.dart';

final riskProfileProvider = StateProvider<RiskProfile?>((ref) => null);

final riskProfileServiceProvider = Provider((ref) => RiskProfileService(ref));

class RiskProfileService {
  final Ref ref;

  RiskProfileService(this.ref);

  RiskProfile evaluateProfile(Map<String, int> answers) {
    final totalScore = answers.values.fold(0, (a, b) => a + b);

    if (totalScore <= 7) {
      return RiskProfile.conservative;
    } else if (totalScore <= 11) {
      return RiskProfile.moderate;
    } else {
      return RiskProfile.aggressive;
    }
  }

  Future<void> saveProfile(RiskProfile profile) async {
    final user = ref.read(appUserProvider);
    if (user != null) {
      final updatedUser = user.copyWith(riskProfile: profile);
      ref.read(appUserProvider.notifier).state = updatedUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'riskProfile': profile.name});
    }

    ref.read(riskProfileProvider.notifier).state = profile;
  }
}