import 'package:flutter/material.dart';
import 'package:harpy/components/screens/home_screen.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/harpy_title.dart';
import 'package:harpy/components/widgets/shared/routes.dart';
import 'package:harpy/core/misc/theme.dart';
import 'package:harpy/models/application_model.dart';
import 'package:harpy/models/login_model.dart';
import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';

/// Shows a [HarpyTitle] and a [LoginButton] to allow a user to login.
class LoginScreen extends StatelessWidget {
  static final Logger _log = Logger("LoginScreen");

  @override
  Widget build(BuildContext context) {
    final loginModel = LoginModel.of(context);
    final applicationModel = ApplicationModel.of(context);

    loginModel.onAuthorized = () => onAuthorized(context);

    return Material(
      color: HarpyTheme.harpyColor,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Center(
              child: HarpyTitle(),
            ),
          ),
          Expanded(
            child: ScopedModelDescendant<LoginModel>(
              builder: (context, _, model) {
                if (model.authorizing || applicationModel.loggedIn) {
                  return Container();
                } else {
                  return LoginButton(onPressed: model.login);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void onAuthorized(BuildContext context) {
    _log.fine("on authorized");

    final applicationModel = ApplicationModel.of(context);

    if (applicationModel.loggedIn) {
      _log.fine("navigating to home screen after login");
      Navigator.of(context).pushReplacement(FadeRoute(
        builder: (context) => HomeScreen(),
      ));
    }
  }
}