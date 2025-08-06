import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/domain/bloc/invitation/invitation_bloc.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/domain/models/roles.dart';
import 'package:dukascango/presentation/helpers/helpers.dart';

class SendInvitationScreen extends StatefulWidget {
  @override
  _SendInvitationScreenState createState() => _SendInvitationScreenState();
}

class _SendInvitationScreenState extends State<SendInvitationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String? _selectedRole;
  final Map<String, bool> _permissions = {
    'View Dashboard': true,
    'Manage Orders': false,
    'Manage Inventory': false,
    'Manage Staff': false,
    'View Financial Reports': false,
  };

  @override
  Widget build(BuildContext context) {
    return BlocListener<InvitationBloc, InvitationState>(
      listener: (context, state) {
        if (state is InvitationLoading) {
          modalLoading(context);
        } else if (state is InvitationSuccess) {
          Navigator.pop(context);
          modalSuccess(context, 'Invitation sent successfully',
              () => Navigator.pop(context));
        } else if (state is InvitationFailure) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const TextCustom(text: 'Send Invitation'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'User Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  items: roles
                      .map((role) => DropdownMenuItem(
                            child: Text(role),
                            value: role,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Role'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a role';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const TextCustom(text: 'Permissions', fontSize: 18),
                ..._permissions.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: _permissions[key],
                    onChanged: (bool? value) {
                      setState(() {
                        _permissions[key] = value!;
                      });
                    },
                  );
                }).toList(),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final permissions = _permissions.entries
                          .where((e) => e.value)
                          .map((e) => e.key)
                          .toList();
                      BlocProvider.of<InvitationBloc>(context).add(
                          OnSendInvitationEvent(_emailController.text,
                              _selectedRole!, permissions));
                    }
                  },
                  child: const Text('Send Invitation'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
