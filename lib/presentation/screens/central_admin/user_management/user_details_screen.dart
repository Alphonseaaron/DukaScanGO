import 'package:dukascango/domain/models/user.dart';
import 'package:dukascango/domain/services/user_services.dart';
import 'package:dukascango/presentation/helpers/modal_delete.dart';
import 'package:dukascango/presentation/helpers/modal_loading.dart';
import 'package:dukascango/presentation/helpers/modal_success.dart';
import 'package:dukascango/presentation/screens/central_admin/user_management/edit_user_screen.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatefulWidget {
  final User user;

  const UserDetailsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditUserScreen(user: _user),
                ),
              ).then((value) {
                if (value == true) {
                  // Reload the user data if it was updated
                  UserServices().getUserById(_user.uid).then((updatedUser) {
                    if (updatedUser != null) {
                      setState(() {
                        _user = updatedUser;
                      });
                    }
                  });
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              modalDelete(context, 'Delete User',
                  'Are you sure you want to delete this user?', () async {
                modalLoading(context);
                await UserServices().deleteUser(_user.uid);
                Navigator.pop(context);
                modalSuccess(context, 'User deleted successfully!',
                    onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true); // Go back to user list
                });
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${_user.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Email: ${_user.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Role: ${_user.rolId}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Status: ', style: TextStyle(fontSize: 18)),
                Text(
                  _user.status,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _user.status == 'active'
                          ? Colors.green
                          : _user.status == 'suspended'
                              ? Colors.orange
                              : Colors.red),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _user.status == 'active'
                      ? null
                      : () => _updateStatus('active'),
                  child: Text('Activate'),
                ),
                ElevatedButton(
                  onPressed: _user.status == 'suspended'
                      ? null
                      : () => _updateStatus('suspended'),
                  child: Text('Suspend'),
                ),
                ElevatedButton(
                  onPressed:
                      _user.status == 'banned' ? null : () => _updateStatus('banned'),
                  child: Text('Ban'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(String status) {
    modalLoading(context);
    UserServices().updateUserStatus(_user.uid, status).then((_) {
      UserServices().getUserById(_user.uid).then((updatedUser) {
        Navigator.pop(context);
        if (updatedUser != null) {
          setState(() {
            _user = updatedUser;
          });
          modalSuccess(context, 'User status updated!',
              onPressed: () => Navigator.pop(context));
        }
      });
    });
  }
}
