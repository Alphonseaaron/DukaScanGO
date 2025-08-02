import 'package:dukascango/presentation/screens/central_admin/user_management/create_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/domain/bloc/user/user_bloc.dart';
import 'package:dukascango/domain/models/roles.dart';
import 'package:dukascango/domain/models/user.dart';
import 'package:dukascango/presentation/components/components.dart';

class StaffManagementScreen extends StatefulWidget {
  @override
  _StaffManagementScreenState createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(OnGetAllUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: 'Staff Management'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateUserScreen(),
                ),
              ).then((_) {
                // Refresh the list when coming back
                BlocProvider.of<UserBloc>(context).add(OnGetAllUsersEvent());
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is LoadingUserState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FailureUserState) {
            return Center(child: TextCustom(text: state.error));
          }
          if (state.users.isNotEmpty) {
            return _ListStaff(users: state.users);
          }
          return const Center(child: Text('No staff found.'));
        },
      ),
    );
  }
}

class _ListStaff extends StatelessWidget {
  final List<User> users;

  const _ListStaff({required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.image ?? ''),
            ),
            title: TextCustom(text: '${user.name} ${user.lastname}'),
            subtitle: TextCustom(text: user.rolId),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit_role') {
                  _showEditRoleDialog(context, user);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit_role',
                  child: Text('Edit Role'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditRoleDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Role'),
          content: DropdownButtonFormField<String>(
            value: user.rolId,
            items: roles
                .map((role) => DropdownMenuItem(
                      child: Text(role),
                      value: role,
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                BlocProvider.of<UserBloc>(context)
                    .add(OnUpdateUserRoleEvent(user, value));
                Navigator.pop(context);
              }
            },
          ),
        );
      },
    );
  }
}
