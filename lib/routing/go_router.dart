import 'package:bastarts_studio_users/presentation/home_screen.dart';
import 'package:bastarts_studio_users/presentation/pricing_screen.dart';
import 'package:bastarts_studio_users/presentation/teacher_info_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router.g.dart';

enum AppRoute { home, pricing }

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => HomeScreen(),
        routes: [
          GoRoute(
            path: 'cenik',
            name: AppRoute.pricing.name,
            builder: (context, state) => PricingScreen(),
          ),
          GoRoute(
            path: 'podrobnosti/:id',
            builder: (context, state) {
              final classId = state.pathParameters['id']!;
              return TeacherInfoScreen(classId);
            },
          ),
        ],
      ),
    ],
  );
}
