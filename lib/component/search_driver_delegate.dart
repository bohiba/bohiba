import '/component/image_path.dart';
import '/extensions/bohiba_extension.dart';
import '/routes/app_route.dart';
import '/services/global_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '/controllers/open_driver_list_controller.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchDriverDelegate extends SearchDelegate {
  final controller = Get.put(OpenDriverListController());

  SearchDriverDelegate() : super(searchFieldLabel: "Search by name, uuid or DL number");
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          controller.results.clear();
          controller.lastQuery = "";
          // showSuggestions(context);
          close(context, null);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    controller.searchUser(query);
    return _buildResultUI();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    controller.searchUser(query);
    return _buildResultUI();
  }

  Widget _buildResultUI() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (query.isNotEmpty && controller.results.isEmpty) {
        return const Center(child: Text("No results found"));
      }

      return ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: controller.results.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final user = controller.results[index];
          NavigatorState navigator = Navigator.of(context);

          return GestureDetector(
            onTap: () {
              navigator.pushNamed(
                AppRoute.openDriver,
                arguments: user,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Container(
                    height: 32.h,
                    width: 32.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bohibaTheme.cardColor,
                    ),
                    child: user.profile?.image == null || (user.profile?.image?.isEmpty ?? true)
                        ? Text(
                            user.profile?.name?.toString().shortCode ?? '',
                            style: TextStyle(
                              fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
                              fontWeight: bohibaTheme.textTheme.bodyMedium!.fontWeight,
                              color: bohibaTheme.textTheme.bodySmall!.color,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(6.r),
                            child: CachedNetworkImage(
                              imageUrl: "${ImagePath.profileImage}/${user.profile?.image}",
                              fit: BoxFit.cover,
                              placeholder: (context, child) {
                                return Image.network(
                                  GlobalService.getAvatarUrl(user.profile?.image ?? ''),
                                );
                              },
                              errorWidget: (context, child, obj) {
                                return Image.network(
                                  GlobalService.getAvatarUrl(user.profile?.image ?? ''),
                                );
                              },
                            ),
                          ),
                  ),
                  Gap(10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.profile?.name ?? '',
                        style: bohibaTheme.textTheme.labelLarge,
                      ),
                      Text(
                        user.profile?.driverUuid ?? '',
                        style: bohibaTheme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

class SearchDriver extends DefaultMaterialLocalizations {
  const SearchDriver();
  @override
  String get searchFieldLabel => "Search by company name";
}
