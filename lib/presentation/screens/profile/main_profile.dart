import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jaclean/blocs/profile/profile_bloc.dart' as profile;
import 'package:jaclean/blocs/profile/profile_account_bloc.dart' as account;
import 'package:jaclean/presentation/widgets/profile_card.dart';
import 'package:jaclean/presentation/widgets/custom_container.dart';
import 'package:jaclean/presentation/widgets/custom_elevated_btn.dart';
import 'package:jaclean/presentation/widgets/custom_list_tile.dart';
import 'package:jaclean/presentation/screens/profile/withdrawal_screen.dart';
import 'package:jaclean/presentation/screens/profile/withdrawal_history.dart';
import 'package:jaclean/presentation/screens/profile/change_password.dart';
import 'package:jaclean/presentation/screens/profile/manage_bank_account_screen.dart';
import 'package:jaclean/presentation/screens/profile/profile_account.dart';
import 'package:jaclean/presentation/theme/app_colors.dart';

class MainProfile extends StatefulWidget {
  const MainProfile({super.key});

  @override
  State<MainProfile> createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool _isBalanceVisible = true; // State to track balance visibility
  bool _isFaceIdEnabled = false; // State to track Face ID & Touch ID switch

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => account.ProfileAccountBloc()..add(account.FetchUserProfile()),
        ),
        BlocProvider(
          create: (context) => profile.ProfileBloc(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profile",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: BlocConsumer<profile.ProfileBloc, profile.ProfileState>(
          listener: (context, state) {
            if (state is profile.SignOutSuccess) {
              Navigator.pushReplacementNamed(context, '/login');
            } else if (state is profile.SignOutFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error signing out: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            return BlocBuilder<account.ProfileAccountBloc, account.ProfileAccountState>(
              builder: (context, state) {
                if (state is account.ProfileAccountLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is account.ProfileAccountFailure) {
                  return Center(child: Text('Error: ${state.error}'));
                } else if (state is account.ProfileLoaded) {
                  final userData = state.userData;
                  final firstName = userData['firstName'] as String? ?? 'User';
                  final lastName = userData['lastName'] as String? ?? '';
                  final userName = userData['userName'] as String? ?? '$firstName $lastName';
                  final email = userData['email'] as String?;
                  final phone = userData['phone'] as String?;
                  final gender = userData['gender'] as String?;
                  final dob = userData['dob'] as Timestamp?;
                  final balance = userData['balance'] as double? ?? 10000.0; // Start balance from 10,000 Naira
                  final selectedAvatar = userData['selectedAvatar'] as String?;

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileCard(
                            firstName: firstName,
                            lastName: lastName,
                            assetUrl: selectedAvatar ?? '',
                            userName: userName,
                          ),
                          // balance section
                          const SizedBox(height: 20),
                          CustomContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Wallet Balance",
                                  style: TextStyle(
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          _isBalanceVisible ? "₦ $balance" : "******",
                                          style: const TextStyle(
                                            color: AppColors.secondaryGreen,
                                            fontSize: 24.24,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: Icon(
                                            _isBalanceVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: AppColors.iconsDark,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isBalanceVisible = !_isBalanceVisible;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    CustomElevatedBtn(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const WithdrawalScreen()),
                                        );
                                      },
                                      text: "Withdraw",
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => WithdrawalHistory()),
                                    );
                                  },
                                  child: const Row(
                                    children: [
                                      Text(
                                        "History",
                                        style: TextStyle(
                                          color: AppColors.primaryRed,
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: AppColors.primaryRed, size: 16),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Action Settings
                          CustomContainer(
                            child: Column(
                              children: [
                                CustomListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileAccount(
                                          firstName: firstName,
                                          lastName: lastName,
                                          userName: userName,
                                          email: email,
                                          phone: phone,
                                          gender: gender,
                                          dob: dob?.toDate(),
                                          avatarUrl: selectedAvatar,
                                        ),
                                      ),
                                    );
                                  },
                                  iconLeading: Icons.person_outlined,
                                  title: 'My Account',
                                  subtitle: 'Make changes to your account',
                                  iconTrailing: Icons.chevron_right,
                                ),
                                CustomListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ManageBankAccountScreen()),
                                    );
                                  },
                                  iconLeading: Icons.person_outlined,
                                  title: "Manage Banks Account",
                                  subtitle: "Manage your saved account",
                                  iconTrailing: Icons.chevron_right,
                                ),
                                CustomListTile(
                                  subtitle: "Manage Your device security",
                                  iconLeading: Icons.lock,
                                  title: "Face ID & Touch ID",
                                  trailing: Switch(
                                    value: _isFaceIdEnabled,
                                    onChanged: (value) {
                                      setState(() {
                                        _isFaceIdEnabled = value;
                                      });
                                    },
                                    activeColor: Colors.green,
                                    inactiveThumbColor: Colors.grey,
                                    inactiveTrackColor: Colors.grey[300],
                                  ),
                                ),
                                CustomListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ChangePassword()),
                                    );
                                  },
                                  iconLeading: Icons.safety_check_sharp,
                                  title: "Change Password",
                                  subtitle: "Further secure your account for safety",
                                  iconTrailing: Icons.chevron_right,
                                ),
                                CustomListTile(
                                  onTap: () {
                                    context.read<profile.ProfileBloc>().add(profile.SignOutUser());
                                  },
                                  iconLeading: Icons.logout,
                                  title: "Log Out",
                                  subtitle: "Further secure your account for safety",
                                  iconTrailing: Icons.chevron_right,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "More",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const CustomContainer(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomListTile(
                                  iconLeading: Icons.notifications,
                                  title: "Help and Support",
                                  iconTrailing: Icons.chevron_right,
                                ),
                                CustomListTile(
                                  iconLeading: Icons.favorite_border_outlined,
                                  title: "About App",
                                  iconTrailing: Icons.chevron_right,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  );
                }

                return const Center(child: Text("No user signed in."));
              },
            );
          },
        ),
      ),
    );
  }
}