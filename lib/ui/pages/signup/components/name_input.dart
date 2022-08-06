
import 'package:forDev/ui/helpers/helpers.dart';
import 'package:forDev/ui/pages/signup/signup_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);

    return StreamBuilder<UiError?>(
      stream: presenter.nameErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.name,
            icon: Icon(Icons.person, color: Theme.of(context).primaryColorLight,),
            errorText: snapshot.data?.description
          ),
          keyboardType: TextInputType.name,
          onChanged: presenter.validateName,
        );
      }
    );
  }
}
