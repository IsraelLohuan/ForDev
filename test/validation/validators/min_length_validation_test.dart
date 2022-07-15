import 'package:ForDev/presentation/protocol/validation.dart';
import 'package:ForDev/validation/protocols/protocols.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

class  MinLengthValidation implements FieldValidation {
  final String field;
  final int size;

  MinLengthValidation({@required this.field, @required this.size});

  @override
  ValidationError validate(String value) {
    if(value != null) {
      if(value.length >= 5) return null;
    }
    
    return ValidationError.invalidField;
  } 
}

void main() {
  MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', size: 5);  
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), ValidationError.invalidField);
  });

  test('Should return error if value is less than min size', () {
    expect(sut.validate(faker.randomGenerator.string(4, min: 1)), ValidationError.invalidField);
  });

  test('Should return null if value is equal than min size', () {
    expect(sut.validate(faker.randomGenerator.string(5, min: 5)), null);
  });
}