import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

import 'presentation/screens/home_page.dart';
import 'presentation/screens/profile_page.dart';
import 'presentation/screens/market/market_page.dart';
import 'presentation/screens/reviews/reviews_page.dart';
import 'presentation/screens/auth/splash_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/auth/onboarding_screen.dart';
import 'presentation/screens/auth/forgot_password_screen.dart';
import 'presentation/utils/bottom_nav.dart';
import 'presentation/screens/services/service_page.dart';
import 'presentation/screens/market/cart_provider.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/splash_bloc.dart';
import 'blocs/market/market_bloc.dart';
import 'blocs/market/add_product_bloc.dart';
import 'blocs/market/cart_bloc.dart';
import 'blocs/market/checkout_bloc.dart';
import 'blocs/market/add_card_bloc.dart';
import 'blocs/market/bank_transfer_bloc.dart';
import 'blocs/market/mobile_money_bloc.dart';
import 'blocs/services/recycling_centers_bloc.dart';
import 'blocs/services/service_bloc.dart';
import 'blocs/services/service_detail_bloc.dart';
import 'blocs/services/user_bloc.dart';
import 'blocs/profile/change_password_bloc.dart';
import 'blocs/profile/manage_bank_account_bloc.dart';
import 'blocs/profile/password_reset_success_dialog_bloc.dart';
import 'blocs/profile/profile_account_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'blocs/profile/withdrawal_bloc.dart';
import 'blocs/profile/withdrawal_history_bloc.dart';
import 'blocs/profile/withdrawal_success_bloc.dart';
import 'blocs/reviews/review_action_bloc.dart';
import 'blocs/reviews/review_page_bloc.dart';
import 'blocs/reviews/write_review_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.INDEXED_DB);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(firebaseAuth: FirebaseAuth.instance)),
        BlocProvider(create: (context) => SplashBloc()),
        BlocProvider(create: (context) => MarketBloc()),
        BlocProvider(create: (context) => AddProductBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => CheckoutBloc(cartBloc: BlocProvider.of<CartBloc>(context))),
        BlocProvider(create: (context) => AddCardBloc()),
        BlocProvider(create: (context) => BankTransferBloc()),
        BlocProvider(create: (context) => MobileMoneyBloc()),
        BlocProvider(create: (context) => RecyclingCentersBloc()),
        BlocProvider(create: (context) => ServiceBloc()),
        BlocProvider(create: (context) => ServiceDetailBloc()),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => ChangePasswordBloc()),
        BlocProvider(create: (context) => ManageBankAccountBloc()),
        BlocProvider(create: (context) => PasswordResetSuccessDialogBloc()),
        BlocProvider(create: (context) => ProfileAccountBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => WithdrawalBloc()),
        BlocProvider(create: (context) => WithdrawalHistoryBloc()),
        BlocProvider(create: (context) => WithdrawalSuccessBloc()),
        BlocProvider(create: (context) => ReviewActionBloc()),
        BlocProvider(create: (context) => ReviewPageBloc()),
        BlocProvider(create: (context) => WriteReviewBloc()),
      ],
      child: MaterialApp(
        title: 'E-Waste Recycling',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/onboarding': (context) => OnboardingScreen(),
          '/forgot-password': (context) => ForgotPasswordScreen(),
          '/service': (context) => ServicePage(),
          '/market': (context) => MarketPage(),
          '/profile': (context) => ProfilePage(),
          '/home': (context) => const MainScreen(),
          '/reviews': (context) => ReviewsPage(),
        },
      ),
    );
  }
}

/// MainScreen with bottom navigation
class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  final List<Widget> _pages = const [
    HomePage(),
    ServicePage(),
    MarketPage(),
    ProfilePage(),
    ReviewsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
