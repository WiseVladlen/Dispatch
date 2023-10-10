import 'package:dispatch/presentation/authentication/login/login_page.dart';
import 'package:dispatch/presentation/authentication/model/authentication_page_model.dart';
import 'package:dispatch/presentation/authentication/sign_up/sign_up_page.dart';
import 'package:dispatch/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
              child: Column(
                children: [
                  const Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    spacing: 20,
                    children: [
                      Text(
                        'Dispatch',
                        style: TextStyles.logoLarge,
                      ),
                      Icon(
                        Icons.messenger,
                        size: 50,
                      ),
                    ],
                  ),
                  const Divider(height: 36, color: Colors.transparent),
                  ChangeNotifierProvider(
                    create: (_) => AuthenticationPageModel(),
                    child: Builder(
                      builder: (context) => context.watch<AuthenticationPageModel>().isLoginPage
                          ? const LoginPage()
                          : const SignUpPage(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
