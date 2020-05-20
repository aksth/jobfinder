import 'package:flutter/material.dart';
import 'package:jobfinder/provider/model/provider_model.dart';

class ProvidersDropdown extends StatefulWidget {

  final Function(ProviderType) onChanged;
  ProviderType initialProvider;

  ProvidersDropdown({Key key, this.onChanged, this.initialProvider}) : super(key : key);

  @override
  _ProvidersDropdownState createState() => _ProvidersDropdownState(onChanged: onChanged, providerType: initialProvider);
}

class _ProvidersDropdownState extends State<ProvidersDropdown>{

  ProviderType providerType;
  Function(ProviderType) onChanged;

  _ProvidersDropdownState({this.onChanged, this.providerType});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ProviderType>(
      items: ProviderType.values.map((ProviderType providerType) {
        return new DropdownMenuItem<ProviderType>(
          value: providerType,
          child: Text(providerType.name),
        );
      }).toList(),
      onChanged: (ProviderType newValue) {
        onChanged(newValue);
        setState(() => providerType = newValue);
      },
      value: providerType,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),),
    );
  }
}