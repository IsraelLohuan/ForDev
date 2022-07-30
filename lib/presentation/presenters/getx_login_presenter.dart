import 'dart:async';
import 'package:ForDev/domain/helpers/domain_error.dart';
import 'package:ForDev/domain/usecases/usecases.dart';
import 'package:ForDev/presentation/mixins/loading_manager.dart';
import 'package:ForDev/presentation/mixins/mixins.dart';
import 'package:ForDev/ui/helpers/errors/errors.dart';
import 'package:ForDev/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:ForDev/presentation/protocol/protocols.dart';

class GetxLoginPresenter extends GetxController with LoadingManager, UiErrorManager, NavigationManager, FormManager implements LoginPresenter {

  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;

  var _emailError = Rx<UiError>();
  var _passwordError = Rx<UiError>();

  Stream<UiError> get emailErrorStream => _emailError.stream;
  Stream<UiError> get passwordErrorStream => _passwordError.stream;
 
  GetxLoginPresenter({
    @required this.validation, 
    @required this.authentication, 
    @required this.saveCurrentAccount
  });

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email');  
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password');
    _validateForm();
  }

  UiError _validateField({String field}) {
    final formData = {
      'email': _email,
      'password': _password
    };
    final error = validation.validate(field: field, input: formData);
    switch(error) {
      case ValidationError.invalidField: return UiError.invalidField;
      case ValidationError.requiredField: return UiError.requiredField;
      default: return null;
    }
  }

  void _validateForm() {
   isFormValid = _emailError.value == null
    && _passwordError.value == null
    && _email != null
    && _password != null;
  }

  Future<void> auth() async {
    try {
      mainError = null;
      isLoading = true;
      final account = await authentication.auth(AuthenticationParams(email: _email, secret: _password));
      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch(error) {
      switch(error) {
        case DomainError.invalidCredentials: mainError = UiError.invalidCredentials; break;
        default: mainError = UiError.unexpected;
      }
      isLoading = false;
    }
  }

  @override
  void goToSignUp() {
    navigateTo = '/signup';
  }
}