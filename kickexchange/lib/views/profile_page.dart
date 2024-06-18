import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kickexchange/controllers/auth_controller.dart';
import 'package:kickexchange/controllers/profile_controller.dart';
import 'package:kickexchange/core/extensions/sized_box_extension.dart';
import 'package:kickexchange/core/preferences/colors.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileController>().getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileController(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Pro",
                style: TextStyle(
                  fontFamily: 'raleway',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.black,
                ),
              ),
              Text(
                "file",
                style: TextStyle(
                  fontFamily: 'montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.orange,
                ),
              ),
            ],
          ),
        ),
        body: Consumer<ProfileController>(
          builder: (context, profileController, child) {
            switch (profileController.state) {
              case ProfileState.loading:
                return const Center(child: CircularProgressIndicator());
              case ProfileState.success:
                final profile = profileController.profileData!;
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            key: UniqueKey(),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.black, width: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: profile.image != null
                                  ? Image.network(
                                      'http://192.168.100.107:3000/uploads/${profile.image}',
                                      key:
                                          UniqueKey(), // Forces refresh when image changes
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  : Image.asset(
                                      'assets/images/default_profile.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () async {
                                final imagePicker = ImagePicker();
                                final XFile? image =
                                    await imagePicker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (image != null) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) async {
                                    await profileController
                                        .uploadImage(image.path);
                                  });
                                }
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.grey,
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.edit,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      40.0.height,
                      TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: profile.username,
                          labelStyle: const TextStyle(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 24,
                            top: 16,
                            bottom: 16,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.black,
                              width: 2,
                            ),
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Icon(Icons.person),
                          ),
                        ),
                      ),
                      16.0.height,
                      TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: profile.email,
                          labelStyle: const TextStyle(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 24,
                            top: 16,
                            bottom: 16,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.black,
                              width: 2,
                            ),
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Icon(Icons.email),
                          ),
                        ),
                      ),
                      40.0.height,
                      SizedBox(
                        height: 56,
                        width: 190,
                        child: ElevatedButton(
                          onPressed: () {
                            logout(context);
                          },
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.black,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 56,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              case ProfileState.error:
                return const Center(
                  child: Text(
                    "Error loading profile",
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              case ProfileState.nodata:
                return const Center(
                  child: Text(
                    "No profile data available",
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
