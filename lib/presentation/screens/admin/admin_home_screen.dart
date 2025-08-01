import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/helpers/helpers.dart';
import 'package:dukascango/presentation/screens/admin/category/categories_admin_screen.dart';
import 'package:dukascango/presentation/screens/admin/dashboard/dashboard_screen.dart';
import 'package:dukascango/presentation/screens/admin/delivery/list_deliverys_screen.dart';
import 'package:dukascango/presentation/screens/admin/orders_admin/orders_admin_screen.dart';
import 'package:dukascango/presentation/screens/admin/products/list_products_screen.dart';
import 'package:dukascango/presentation/screens/admin/self_scan_orders/self_scan_orders_screen.dart';
import 'package:dukascango/presentation/screens/admin/inventory/bulk_upload_screen.dart';
import 'package:dukascango/presentation/screens/admin/inventory/restocking_requests_screen.dart';
import 'package:dukascango/presentation/screens/admin/financial_reporting/financial_reporting_screen.dart';
import 'package:dukascango/presentation/screens/admin/staff/staff_management_screen.dart';
import 'package:dukascango/presentation/screens/home/select_role_screen.dart';
import 'package:dukascango/presentation/screens/intro/checking_login_screen.dart';
import 'package:dukascango/presentation/screens/profile/change_password_screen.dart';
import 'package:dukascango/presentation/screens/profile/edit_Prodile_screen.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';

class AdminHomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadingUserState) {
          modalLoading(context);
        } else if (state is SuccessUserState) {

          Navigator.pop(context);
          modalSuccess(context, 'Picture Change Successfully', () => Navigator.pushReplacement(context, routeDukascango(page: AdminHomeScreen())));
          Navigator.pop(context);

        } else if (state is FailureUserState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              Align(alignment: Alignment.center, child: ImagePickerDukascango()),
              const SizedBox(height: 10.0),
              Center(
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (_, state) 
                    => TextCustom( text: ( state.user != null) ? state.user!.firstName.toUpperCase() + ' ' + state.user!.lastName.toUpperCase() : '',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        maxLine: 1,
                        textAlign: TextAlign.center,
                        color: ColorsDukascango.secundaryColor
                      )
                )
              ),
              const SizedBox(height: 5.0),
              Center(
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (_, state) 
                      => TextCustom( text: (state.user != null ) ? state.user!.email : '', fontSize: 20, color: ColorsDukascango.secundaryColor)
                  )
              ),
              const SizedBox(height: 15.0),
              const TextCustom(text: 'Account', color: Colors.grey),
              const SizedBox(height: 10.0),
              ItemAccount(
                text: 'Profile setting',
                icon: Icons.person,
                colorIcon: 0xff01C58C,
                onPressed: () => Navigator.push(
                    context, routeDukascango(page: EditProfileScreen())),
              ),
              ItemAccount(
                text: 'Change Password',
                icon: Icons.lock_rounded,
                colorIcon: 0xff1B83F5,
                onPressed: () => Navigator.push(
                    context, routeDukascango(page: ChangePasswordScreen())),
              ),
              ItemAccount(
                text: 'Change Role',
                icon: Icons.swap_horiz_rounded,
                colorIcon: 0xffE62755,
                onPressed: () => Navigator.pushAndRemoveUntil(context, routeDukascango(page: SelectRoleScreen()), (route) => false),
              ),
              ItemAccount(
                text: 'Dark mode',
                icon: Icons.dark_mode_rounded,
                colorIcon: 0xff051E2F,
              ),
              const SizedBox(height: 15.0),
              const TextCustom(text: 'Dukascango', color: Colors.grey),
              const SizedBox(height: 10.0),
              ItemAccount(
                text: 'Dashboard',
                icon: Icons.dashboard_rounded,
                colorIcon: 0xff0C6CF2,
                onPressed: () => Navigator.push(
                    context, routeDukascango(page: DashboardScreen())),
              ),
              ItemAccount(
                text: 'Categories',
                icon: Icons.category_rounded,
                colorIcon: 0xff5E65CD,
                onPressed: () => Navigator.push(
                    context, routeDukascango(page: CategoriesAdminScreen())),
              ),
              ItemAccount(
                text: 'Products',
                icon: Icons.add,
                colorIcon: 0xff355773,
                onPressed: () => Navigator.push(
                    context, routeDukascango(page: ListProductsScreen())),
              ),
              ItemAccount(
                text: 'Bulk Upload',
                icon: Icons.upload_file_rounded,
                colorIcon: 0xff8E44AD,
                onPressed: () => Navigator.push(
                    context, routeDukascango(page: BulkUploadScreen())),
              ),
              ItemAccount(
                text: 'Restocking Requests',
                icon: Icons.inventory_rounded,
                colorIcon: 0xffF1C40F,
                onPressed: () => Navigator.push(
                    context, routeDukascango(page: RestockingRequestsScreen())),
              ),
              ItemAccount(
                text: 'Financial Reporting',
                icon: Icons.assessment_rounded,
                colorIcon: 0xff1ABC9C,
                onPressed: () => Navigator.push(
                    context, routeDukascango(page: FinancialReportingScreen())),
              ),
              ItemAccount(
                text: 'Staff Management',
                icon: Icons.people_alt_rounded,
                colorIcon: 0xff3498DB,
                onPressed: () => Navigator.push(
                    context, routeDukascango(page: StaffManagementScreen())),
              ),
              ItemAccount(
                text: 'Delivery',
                icon: Icons.delivery_dining_rounded,
                colorIcon: 0xff469CD7,
                onPressed: () => Navigator.push(
                    context, routeDukascango(page: ListDeliverysScreen())),
              ),
              ItemAccount(
                text: 'Orders',
                icon: Icons.checklist_rounded,
                colorIcon: 0xffFFA136,
                onPressed: () => Navigator.push(
                    context, routeDukascango(page: OrdersAdminScreen())),
              ),
              ItemAccount(
                text: 'Self-Scan Orders',
                icon: Icons.qr_code_scanner_rounded,
                colorIcon: 0xff2BDD99,
                onPressed: () => Navigator.push(
                    context, routeDukascango(page: SelfScanOrdersScreen())),
              ),
              const SizedBox(height: 15.0),
              const TextCustom(text: 'Personal', color: Colors.grey),
              const SizedBox(height: 10.0),
              ItemAccount(
                text: 'Privacy & Policy',
                icon: Icons.policy_rounded,
                colorIcon: 0xff6dbd63,
              ),
              ItemAccount(
                text: 'Security',
                icon: Icons.lock_outline_rounded,
                colorIcon: 0xff1F252C,
              ),
              ItemAccount(
                text: 'Term & Conditions',
                icon: Icons.description_outlined,
                colorIcon: 0xff458bff,
              ),
              ItemAccount(
                text: 'Help',
                icon: Icons.help_outline,
                colorIcon: 0xff4772e6,
              ),
              const Divider(),
              ItemAccount(
                text: 'Sign Out',
                icon: Icons.power_settings_new_sharp,
                colorIcon: 0xffF02849,
                onPressed: () {
                  authBloc.add(LogOutEvent());
                  Navigator.pushAndRemoveUntil(
                    context,
                    routeDukascango(page: CheckingLoginScreen()), (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
