import 'package:forDev/validation/protocols/protocols.dart';
import 'package:meta/meta.dart';
import 'package:forDev/presentation/protocol/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  ValidationError validate({@required String field, @required Map input}) {
    ValidationError error;

    for(final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(input);
      if(error != null) {
        return error;
      }
    }

    return error;
  } 
}