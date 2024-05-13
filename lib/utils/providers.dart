
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

ProviderContainer providerContainer = ProviderContainer();

final loggedInUserProvider = StateProvider<User?>((ref) => null);
