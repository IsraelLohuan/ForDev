
import 'package:ForDev/presentation/protocol/protocols.dart';
import 'package:ForDev/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should return null if email is empty', () {
    expect(sut.validate({'any_field': ''}), null);
  });

  test('Should return null if email is empty', () {
    expect(sut.validate({'any_field': null}), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate({'any_field': 'srlohuan@gmail.com'}), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate({'any_field': 'srlohuangmailcom'}), ValidationError.invalidField);
  });
}