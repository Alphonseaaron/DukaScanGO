import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/presentation/helpers/helpers.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';
import 'package:dukascango/presentation/components/text_custom.dart';

class PictureRegistre extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
          border:
              Border.all(style: BorderStyle.solid, color: Colors.grey[300]!),
          shape: BoxShape.circle),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => modalPictureRegister(
            ctx: context,
            onPressedChange: () async {
              final permissionGallery = await Permission.photos.request();

              switch (permissionGallery) {
                case PermissionStatus.granted:
                  Navigator.pop(context);
                  final XFile? imagePath =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (imagePath != null)
                    userBloc.add(OnSelectPictureEvent(imagePath.path));
                  break;
                case PermissionStatus.denied:
                case PermissionStatus.restricted:
                case PermissionStatus.limited:
                case PermissionStatus.permanentlyDenied:
                case PermissionStatus.provisional:
                  openAppSettings();
                  break;
              }
            },
            onPressedTake: () async {
              final permissionPhotos = await Permission.camera.request();

              switch (permissionPhotos) {
                case PermissionStatus.granted:
                  Navigator.pop(context);
                  final XFile? photoPath =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (photoPath != null)
                    userBloc.add(OnSelectPictureEvent(photoPath.path));
                  break;

                case PermissionStatus.denied:
                case PermissionStatus.restricted:
                case PermissionStatus.limited:
                case PermissionStatus.permanentlyDenied:
                case PermissionStatus.provisional:
                  openAppSettings();
                  break;
              }
            }),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) => state.pictureProfilePath == ''
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.wallpaper_rounded,
                        size: 60, color: ColorsDukascango.primaryColor),
                    SizedBox(height: 10.0),
                    TextCustom(text: 'Picture', color: Colors.grey)
                  ],
                )
              : Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(state.pictureProfilePath)))),
                ),
        ),
      ),
    );
  }
}
