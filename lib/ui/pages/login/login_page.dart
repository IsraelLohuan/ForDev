
import 'package:forDev/ui/components/components.dart';
import 'package:forDev/ui/helpers/errors/errors.dart';
import 'package:forDev/ui/helpers/helpers.dart';
import 'package:forDev/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'components/components.dart';
import 'package:forDev/ui/mixins/mixins.dart';

class LoginPage extends StatelessWidget with KeyBoardManager, LoadingManager, UiErrorManager, NavigationManager {
  final LoginPresenter presenter;

  LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          handleLoading(context, presenter.isLoadingStream);    
          handleMainError(context, presenter.mainErrorStream);
          handleNavigation(presenter.navigateToStream, clear: true);

          return GestureDetector(
            onTap: () => hideKeyboard(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  HeadLine1(text: R.strings.login,),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Provider(
                      create: (_) => presenter,
                      child: Form(
                        child: Column(
                          children: [
                            EmailInput(),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 32),
                              child: PasswordInput(),
                            ),
                            LoginButton(),
                            FlatButton.icon(
                              onPressed: presenter.goToSignUp, 
                              icon: Icon(Icons.person), 
                              label: Text(R.strings.addAccount)
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]
              )
            ),
          );
        },
      ),
    );
  }
}






