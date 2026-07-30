import 'package:bohiba/component/bohiba_inputfield/date_inputfield.dart';
import 'package:bohiba/component/bohiba_inputfield/text_inputfield.dart';
import 'package:bohiba/services/global_service.dart';

import '/component/bohiba_buttons/primary_button.dart';
import '/pages/widget/required_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

import '/component/app_skeleton_loader.dart';
import '/component/bohiba_dropdown/app_search_dropdown_button.dart';
import '/controllers/owner_company_controller.dart';
import '/dist/component_exports.dart';
import '/model/location_model.dart';
import '/model/owner_company_model.dart';
import '/services/api_end_point.dart';
import '/theme/bohiba_theme.dart';

// ── Entry point ───────────────────────────────────────────────────────────────

class OwnerCompanyPage extends GetView<OwnerCompanyController> {
  const OwnerCompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(title: 'My Company'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Padding(
            padding: EdgeInsets.all(16.r),
            child: AppSkeletonLoader(skeletonLength: 6),
          );
        }
        if (controller.company.value == null) {
          return _NoCompanyState(
            onCreate: () => _showProfileSheet(context, isCreate: true),
          );
        }
        return _CompanyBody(context: context);
      }),
    );
  }

  // ── Profile bottom sheet ──────────────────────────────────────
  void _showProfileSheet(BuildContext context, {required bool isCreate}) {
    if (!isCreate) controller.populateProfileForm();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bohibaTheme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => _ProfileSheet(isCreate: isCreate),
    );
  }
}

// ── Body (when company exists) ────────────────────────────────────────────────

class _CompanyBody extends StatelessWidget {
  final BuildContext context;
  const _CompanyBody({required this.context});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerCompanyController>();
    return RefreshIndicator(
      onRefresh: controller.fetchCompany,
      color: bohibaTheme.primaryColor,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        children: [
          Obx(() => _HeroCard(
                company: controller.company.value!,
                onChangeLogo: controller.pickAndUploadLogo,
                onEdit: () {
                  controller.populateProfileForm();
                  _showEditSheet(context);
                },
              )),
          Gap(16.h),
          Obx(() => _StatusBanner(
                status: controller.company.value?.status,
              )),
          Gap(16.h),
          _SectionHeader(
            title: 'Address',
            icon: RemixIcons.map_pin_2_line,
            onTap: () {
              controller.populateAddressForm();
              _showAddressSheet(context);
            },
            actionLabel: '+ Add',
          ),
          Gap(8.h),
          Obx(() {
            final addr = controller.company.value?.address;
            if (addr == null) {
              return _EmptyCard(
                label: 'No address added yet.',
                onTap: () {
                  controller.populateAddressForm();
                  _showAddressSheet(context);
                },
              );
            }
            return _AddressCard(address: addr);
          }),
          Gap(16.h),
          _SectionHeader(
            title: 'Contacts',
            icon: RemixIcons.group_line,
            onTap: () {
              controller.clearContactForm();
              _showContactSheet(context);
            },
            actionLabel: '+ Add',
          ),
          Gap(8.h),
          Obx(() {
            final contacts = controller.company.value?.contacts ?? [];
            if (contacts.isEmpty) {
              return _EmptyCard(
                label: 'No contacts added yet.',
                onTap: () {
                  controller.clearContactForm();
                  _showContactSheet(context);
                },
              );
            }
            return Column(
              children: contacts
                  .map((c) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: _ContactCard(contact: c),
                      ))
                  .toList(),
            );
          }),
          Gap(16.h),
          // ── Legal Details (BR-09 / BR-11) ────────────────────────
          Obx(() {
            final legal = controller.company.value?.legal;
            return _SectionHeader(
              title: 'Legal Details',
              icon: RemixIcons.government_line,
              onTap: legal == null
                  ? () => _showLegalSheet(context)
                  : () {}, // BR-09: no edit after first submission
              actionLabel: legal == null ? '+ Submit' : null,
            );
          }),
          Gap(8.h),
          Obx(() {
            final legal = controller.company.value?.legal;
            if (legal == null) {
              return _LegalEmptyCard(
                onTap: () => _showLegalSheet(context),
              );
            }
            return _LegalCard(legal: legal);
          }),
          Gap(32.h),
        ],
      ),
    );
  }

  void _showLegalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bohibaTheme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => const _LegalSheet(),
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bohibaTheme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => const _ProfileSheet(isCreate: false),
    );
  }

  void _showAddressSheet(BuildContext context) {
    Get.find<OwnerCompanyController>().ensureLocationsForAddressSheet();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bohibaTheme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => const _AddressSheet(),
    );
  }

  void _showContactSheet(BuildContext context, {CompanyContact? existing}) {
    if (existing != null) {
      Get.find<OwnerCompanyController>().populateContactForm(existing);
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bohibaTheme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => _ContactSheet(existing: existing),
    );
  }
}

// ── Hero card ─────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final OwnerCompanyModel company;
  final VoidCallback onChangeLogo;
  final VoidCallback onEdit;

  const _HeroCard({
    required this.company,
    required this.onChangeLogo,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            bohibaTheme.primaryColor,
            bohibaTheme.primaryColor.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              GestureDetector(
                onTap: onChangeLogo,
                child: Stack(
                  children: [
                    Container(
                      width: 72.r,
                      height: 72.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5),
                      ),
                      child: company.logo != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(11.r),
                              child: Image.network(
                                '${ApiEndPoint.baseUrl.replaceAll('/api', '')}/storage/app/public/${company.logo}',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _LogoPlaceholder(name: company.name),
                              ),
                            )
                          : _LogoPlaceholder(name: company.name),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 22.r,
                        height: 22.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(
                          RemixIcons.camera_line,
                          size: 13.r,
                          color: bohibaTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name ?? 'My Company',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    if (company.nameCode != null) ...[
                      Gap(3.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          company.nameCode ?? "",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Gap(8.w),
              GestureDetector(
                onTap: onEdit,
                child: Icon(
                  RemixIcons.pencil_fill,
                  color: Colors.white,
                  size: 20.r,
                ),
              ),
            ],
          ),
          Gap(14.h),
          // Info row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (company.phone != null)
                _HeroInfoChip(
                    icon: RemixIcons.phone_line, label: company.phone!),
              if (company.email != null) ...[
                Gap(8.w),
                _HeroInfoChip(
                    icon: RemixIcons.mail_line, label: company.email!),
              ],
            ],
          ),
          if (company.website != null) ...[
            Gap(6.h),
            _HeroInfoChip(
                icon: RemixIcons.global_line, label: company.website!),
          ],
        ],
      ),
    );
  }
}

class _LogoPlaceholder extends StatelessWidget {
  final String? name;
  const _LogoPlaceholder({this.name});

  @override
  Widget build(BuildContext context) {
    final initials = (name ?? 'C')
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _HeroInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeroInfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size: 12.r, color: BohibaColors.white),
        Gap(4.w),
        Flexible(
          child: Text(
            label,
            style: TextStyle(color: BohibaColors.white, fontSize: 11.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String? status;
  const _StatusBanner({this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    String label;

    switch (status) {
      case kStatusOperating:
        bg = BohibaColors.successColor.withValues(alpha: 0.1);
        fg = BohibaColors.successColor;
        icon = RemixIcons.shield_check_line;
        label = 'Your company is active and visible in transporter search.';
        break;
      case kStatusShelved:
      case kStatusRetired:
        bg = BohibaColors.greyColor.withValues(alpha: 0.1);
        fg = BohibaColors.greyColor;
        icon = RemixIcons.pause_circle_line;
        label =
            'Your company is currently ${companyStatusLabel(status).toLowerCase()}. Contact support.';
        break;
      default: // PENDING
        bg = const Color(0xFFFFF3CD);
        fg = const Color(0xFF856404);
        icon = RemixIcons.time_line;
        label =
            'Pending admin approval. Your company will appear in search once approved.';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 18.r, color: fg),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  companyStatusLabel(status),
                  style: TextStyle(
                    color: fg,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gap(2.h),
                Text(
                  label,
                  style: TextStyle(color: fg, fontSize: 11.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Address card ──────────────────────────────────────────────────────────────

class _AddressCard extends StatelessWidget {
  final CompanyAddress address;
  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(14.r),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: bohibaTheme.canvasColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: bohibaTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (address.address != null)
            _AddrRow(RemixIcons.map_pin_line, address.address!),
          if (address.districtName != null || address.stateName != null)
            _AddrRow(
              RemixIcons.map_2_line,
              [address.districtName, address.stateName]
                  .where((s) => s != null && s.isNotEmpty)
                  .join(', '),
            ),
          if (address.pincode != null)
            _AddrRow(RemixIcons.mail_line, 'PIN ${address.pincode}'),
          if (address.country != null)
            _AddrRow(RemixIcons.earth_line, address.country!),
        ],
      ),
    );
  }
}

class _AddrRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _AddrRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14.r, color: BohibaColors.greyColor),
          Gap(8.w),
          Expanded(
            child: Text(
              text,
              style: bohibaTheme.textTheme.bodySmall?.copyWith(fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Contact card ──────────────────────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  final CompanyContact contact;
  const _ContactCard({required this.contact});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerCompanyController>();
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: bohibaTheme.canvasColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: bohibaTheme.dividerColor),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: bohibaTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Text(
                (contact.name ?? 'C')[0].toUpperCase(),
                style: TextStyle(
                  color: bohibaTheme.primaryColor,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name ?? '-',
                  style: bohibaTheme.textTheme.titleSmall
                      ?.copyWith(fontSize: 13.sp),
                ),
                Gap(3.h),
                Row(
                  children: [
                    _DesignationChip(contact.designationLabel),
                    if (contact.phone != null) ...[
                      Gap(6.w),
                      Icon(RemixIcons.phone_line,
                          size: 11.r, color: BohibaColors.greyColor),
                      Gap(3.w),
                      Text(
                        contact.phone!,
                        style: bohibaTheme.textTheme.bodySmall
                            ?.copyWith(fontSize: 11.sp),
                      ),
                    ],
                  ],
                ),
                if (contact.email != null) ...[
                  Gap(2.h),
                  Text(
                    contact.email!,
                    style: bohibaTheme.textTheme.bodySmall?.copyWith(
                        fontSize: 10.sp, color: BohibaColors.greyColor),
                  ),
                ],
              ],
            ),
          ),
          // Actions
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  controller.populateContactForm(contact);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: bohibaTheme.scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.r)),
                    ),
                    builder: (_) => _ContactSheet(existing: contact),
                  );
                },
                child: Icon(RemixIcons.pencil_line,
                    size: 18.r, color: bohibaTheme.primaryColor),
              ),
              Gap(8.h),
              GestureDetector(
                onTap: () => controller.deleteContact(contact.id!),
                child: Icon(RemixIcons.delete_bin_line,
                    size: 18.r, color: BohibaColors.warningColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DesignationChip extends StatelessWidget {
  final String label;
  const _DesignationChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bohibaTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: bohibaTheme.primaryColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ── Shared UI pieces ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final String? actionLabel;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.onTap,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: bohibaTheme.primaryColor),
        Gap(6.w),
        Text(
          title,
          style: bohibaTheme.textTheme.headlineMedium
              ?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        if (actionLabel != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              actionLabel ?? '',
              style: TextStyle(
                color: bohibaTheme.primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _EmptyCard({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: bohibaTheme.cardColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
              color: bohibaTheme.primaryColor.withValues(alpha: 0.3),
              width: 1,
              style: BorderStyle.solid),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(RemixIcons.add_circle_line,
                  size: 16.r, color: bohibaTheme.primaryColor),
              Gap(6.w),
              Text(
                label,
                style:
                    TextStyle(color: bohibaTheme.primaryColor, fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── No company state ──────────────────────────────────────────────────────────

class _NoCompanyState extends StatelessWidget {
  final VoidCallback onCreate;
  const _NoCompanyState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                color: bohibaTheme.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Icon(
                RemixIcons.building_2_line,
                size: 46.r,
                color: bohibaTheme.primaryColor,
              ),
            ),
            Gap(20.h),
            Text(
              'No company registered',
              style:
                  bohibaTheme.textTheme.titleMedium?.copyWith(fontSize: 17.sp),
              textAlign: TextAlign.center,
            ),
            Gap(8.h),
            Text(
              'Register your transport company to appear in transporter search and issue formal lorry receipts.',
              style: bohibaTheme.textTheme.bodySmall
                  ?.copyWith(color: BohibaColors.greyColor),
              textAlign: TextAlign.center,
            ),
            Gap(28.h),
            ElevatedButton.icon(
              onPressed: onCreate,
              icon: Icon(RemixIcons.add_line, size: 18.r, color: Colors.white),
              label: Text(
                'REGISTER COMPANY',
                style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: bohibaTheme.primaryColor,
                minimumSize: Size(double.infinity, 46.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Profile bottom sheet ──────────────────────────────────────────────────────

class _ProfileSheet extends StatelessWidget {
  final bool isCreate;
  const _ProfileSheet({required this.isCreate});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerCompanyController>();
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHandle(),
            Gap(4.h),
            Text(
              isCreate ? 'Register Company' : 'Edit Company',
              style: bohibaTheme.textTheme.titleMedium,
            ),
            Gap(16.h),
            RequiredLabel(
              label: 'Company Name',
              required: true,
            ),
            TextInputField(
                controller: controller.nameCtrl,
                hintText: 'e.g. Mahanta Fleet Services'),
            RequiredLabel(label: 'Email'),
            TextInputField(
                controller: controller.emailCtrl,
                hintText: 'company@email.com',
                keyboardType: TextInputType.emailAddress),
            RequiredLabel(label: 'Phone'),
            TextInputField(
              controller: controller.phoneCtrl,
              hintText: '9xxxxxxxxx',
              keyboardType: TextInputType.phone,
              maxLength: 10,
            ),
            RequiredLabel(label: 'Website'),
            TextInputField(
              controller: controller.websiteCtrl,
              maxLines: 1,
              hintText: 'https://...',
              keyboardType: TextInputType.url,
            ),
            Gap(10.h),
            PrimaryButton(
              onPressed: (isCreate
                  ? controller.createCompany
                  : controller.updateCompany),
              label: isCreate ? 'REGISTER' : 'SAVE CHANGES',
            ),
          ],
        ),
      ),
    );
  }
}

// ── Address bottom sheet ──────────────────────────────────────────────────────

class _AddressSheet extends StatelessWidget {
  const _AddressSheet();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerCompanyController>();
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHandle(),
            Text(
              'Company Address',
              style: bohibaTheme.textTheme.titleMedium,
            ),
            Gap(16.h),
            RequiredLabel(
              label: 'Street / Area',
              required: true,
            ),
            TextInputField(
              controller: controller.addressCtrl,
              hintText: 'Street, locality, area',
              maxLines: 2,
            ),

            // ── State dropdown ────────────────────────────────────────
            RequiredLabel(
              label: 'State',
              required: true,
            ),
            Obx(() {
              final loading = controller.isLoadingLocations.value;
              final stateList = controller.states;
              if (loading) {
                return _LocationLoadingIndicator(label: 'Loading states...');
              }
              if (stateList.isEmpty) {
                return _LocationRetryRow(
                  label: 'Failed to load states',
                  onRetry: controller.ensureLocationsForAddressSheet,
                );
              }
              final selected = stateList.cast<StateModel?>().firstWhere(
                    (s) => s?.id == controller.selectedStateId.value,
                    orElse: () => null,
                  );
              return AppDropdownSearch<StateModel>(
                items: stateList.toList(),
                labelBuilder: (s) => s.name,
                initialValue: selected,
                hint: 'Select state',
                enableSearch: true,
                onChanged: controller.onStateSelected,
              );
            }),

            // ── District dropdown (filtered by selected state) ────────
            RequiredLabel(
              label: 'District',
              required: true,
            ),
            Obx(() {
              final loading = controller.isLoadingLocations.value;
              final districtList = controller.districtsForSelectedState;
              if (loading) {
                return _LocationLoadingIndicator(label: 'Loading districts...');
              }
              if (controller.locationData.value != null &&
                  districtList.isEmpty &&
                  controller.selectedStateId.value != null) {
                return _LocationRetryRow(
                  label: 'No districts for selected state',
                  onRetry: null,
                );
              }
              final selected = districtList.cast<DistrictModel?>().firstWhere(
                    (d) => d?.id == controller.selectedDistrictId.value,
                    orElse: () => null,
                  );
              return AppDropdownSearch<DistrictModel>(
                items: districtList.toList(),
                labelBuilder: (d) => d.name,
                initialValue: selected,
                hint: controller.selectedStateId.value == null
                    ? 'Select a state first'
                    : 'Select district',
                enableSearch: true,
                onChanged: controller.selectedStateId.value == null
                    ? null
                    : controller.onDistrictSelected,
              );
            }),
            Gap(10.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RequiredLabel(
                        label: 'Pincode',
                        required: true,
                      ),
                      TextInputField(
                        controller: controller.pincodeCtrl,
                        hintText: '6-digit PIN',
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                      ),
                    ],
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RequiredLabel(
                        label: 'Country',
                        required: true,
                      ),
                      TextInputField(
                        controller: controller.countryCtrl,
                        hintText: 'INDIA',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(10.h),
            PrimaryButton(
              onPressed: controller.saveAddress,
              label: 'SAVE ADDRESS',
            ),
          ],
        ),
      ),
    );
  }
}

// ── Location picker helper widgets ────────────────────────────────────────────

class _LocationLoadingIndicator extends StatelessWidget {
  final String label;
  const _LocationLoadingIndicator({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: bohibaTheme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: bohibaTheme.dividerColor),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 14.r,
            height: 14.r,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: bohibaTheme.primaryColor),
          ),
          Gap(10.w),
          Text(label,
              style: bohibaTheme.textTheme.bodySmall
                  ?.copyWith(color: BohibaColors.greyColor, fontSize: 12.sp)),
        ],
      ),
    );
  }
}

class _LocationRetryRow extends StatelessWidget {
  final String label;
  final VoidCallback? onRetry;
  const _LocationRetryRow({required this.label, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: BohibaColors.warningColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
        border:
            Border.all(color: BohibaColors.warningColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(RemixIcons.alert_line,
              size: 14.r, color: BohibaColors.warningColor),
          Gap(8.w),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    color: BohibaColors.warningColor, fontSize: 12.sp)),
          ),
          if (onRetry != null)
            GestureDetector(
              onTap: onRetry,
              child: Text('Retry',
                  style: TextStyle(
                      color: bohibaTheme.primaryColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}

// ── Contact bottom sheet ──────────────────────────────────────────────────────

class _ContactSheet extends GetView<OwnerCompanyController> {
  final CompanyContact? existing;
  const _ContactSheet({this.existing});

  @override
  Widget build(BuildContext context) {
    final isEdit = existing != null;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHandle(),
            Text(isEdit ? 'Edit Contact' : 'Add Contact',
                style: bohibaTheme.textTheme.titleMedium),
            Gap(16.h),
            RequiredLabel(label: 'Designation'),
            Obx(() {
              final selected = controller.selectedDesignation.value;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: kDesignationLabels.entries.map((e) {
                    final isSelected = selected == e.key;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: ChoiceChip(
                        selected: isSelected,
                        selectedColor: bohibaTheme.primaryColor,
                        backgroundColor: bohibaTheme.cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? bohibaTheme.textTheme.displayLarge?.color
                              : bohibaTheme.textTheme.labelLarge?.color,
                          fontSize: 12.sp,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        onSelected: (_) {
                          controller.selectedDesignation.value = e.key;
                        },
                        label: Text(e.value),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
            RequiredLabel(
              label: 'Full Name',
              required: true,
            ),
            TextInputField(
                controller: controller.contactNameCtrl,
                hintText: 'Contact name'),
            RequiredLabel(
              label: 'Phone',
              required: true,
            ),
            TextInputField(
                controller: controller.contactPhoneCtrl,
                maxLength: 10,
                hintText: '9xxxxxxxxx',
                keyboardType: TextInputType.phone),
            RequiredLabel(
              label: 'Email',
            ),
            TextInputField(
                controller: controller.contactEmailCtrl,
                hintText: 'example@gmail.com',
                keyboardType: TextInputType.emailAddress),
            RequiredLabel(label: 'Address'),
            TextInputField(
              controller: controller.contactAddressCtrl,
              hintText: 'Contact personal address',
              maxLines: 3,
            ),
            RequiredLabel(label: 'Date of appointment'),
            Obx(() {
              final textCtrl = controller.contactAppointedDate.value;
              return DateInputField(
                hintText:
                    textCtrl.text.isNotEmpty ? textCtrl.text : 'DD-MM-YYYY',
                showPrefixIcon: false,
                onTap: () async {
                  final picked = await GlobalService.datePickerModal(
                    context: context,
                  );
                  if (picked != null) {
                    controller.contactAppointedDate.value.text =
                        DateFormat('dd-MM-yyyy').format(picked);
                    controller.contactAppointedDate.refresh();
                  }
                },
              );
            }),
            Gap(20.h),
            PrimaryButton(
              onPressed: (isEdit
                  ? () => controller.updateContact(existing!.id!)
                  : controller.addContact),
              label: isEdit ? 'UPDATE CONTACT' : 'ADD CONTACT',
            )
          ],
        ),
      ),
    );
  }
}

// ── Reusable sheet helpers ────────────────────────────────────────────────────

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40.w,
        height: 4.h,
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: bohibaTheme.dividerColor,
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }
}

// ── Legal Details — empty state ───────────────────────────────────────────────

class _LegalEmptyCard extends StatelessWidget {
  final VoidCallback onTap;
  const _LegalEmptyCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: bohibaTheme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFFFFC107).withValues(alpha: 0.6),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                RemixIcons.file_shield_2_line,
                size: 20.r,
                color: const Color(0xFF856404),
              ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Legal details not submitted',
                    style: bohibaTheme.textTheme.titleSmall
                        ?.copyWith(fontSize: 13.sp),
                  ),
                  Gap(3.h),
                  Text(
                    'Submit GST / PAN / CIN once. Cannot be edited after submission.',
                    style: bohibaTheme.textTheme.bodySmall?.copyWith(
                      color: BohibaColors.greyColor,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            Gap(8.w),
            Icon(RemixIcons.arrow_right_s_line,
                size: 18.r, color: const Color(0xFF856404)),
          ],
        ),
      ),
    );
  }
}

// ── Legal Details — read-only card (BR-09: no edit after submission) ──────────

class _LegalCard extends StatelessWidget {
  final CompanyLegal legal;
  const _LegalCard({required this.legal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: bohibaTheme.canvasColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: bohibaTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(RemixIcons.lock_line,
                  size: 12.r, color: BohibaColors.greyColor),
              Gap(4.w),
              Text(
                'Write-once — contact admin to make corrections',
                style:
                    TextStyle(color: BohibaColors.greyColor, fontSize: 10.sp),
              ),
            ],
          ),
          Divider(height: 14.h, color: bohibaTheme.dividerColor),
          if (legal.gstNo != null)
            _LegalRow(label: 'GST No', value: legal.gstNo!),
          if (legal.panNo != null)
            _LegalRow(label: 'PAN No', value: legal.panNo!),
          if (legal.cinNo != null)
            _LegalRow(label: 'CIN No', value: legal.cinNo!),
          if (legal.registrationType != null)
            _LegalRow(
                label: 'Registration Type', value: legal.registrationType!),
          if (legal.establishedYear != null)
            _LegalRow(
                label: 'Established', value: legal.establishedYear!.toString()),
        ],
      ),
    );
  }
}

class _LegalRow extends StatelessWidget {
  final String label;
  final String value;
  const _LegalRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: bohibaTheme.textTheme.bodySmall?.copyWith(
                color: BohibaColors.greyColor,
                fontSize: 11.sp,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: bohibaTheme.textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Legal submit sheet (one-time; no edit path) ───────────────────────────────

class _LegalSheet extends StatelessWidget {
  const _LegalSheet();

  static const _registrationTypes = [
    'Proprietorship',
    'Partnership',
    'LLP',
    'Private Limited',
    'Public Limited',
    'One Person Company',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerCompanyController>();
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHandle(),
            Gap(4.h),
            Text('Legal Details', style: bohibaTheme.textTheme.titleMedium),
            Gap(8.h),
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(RemixIcons.alert_line,
                      size: 14.r, color: const Color(0xFF856404)),
                  Gap(8.w),
                  Expanded(
                    child: Text(
                      'These details are write-once and cannot be edited or deleted once submitted. Verify carefully before submitting.',
                      style: TextStyle(
                          color: const Color(0xFF856404), fontSize: 11.sp),
                    ),
                  ),
                ],
              ),
            ),
            Gap(16.h),
            RequiredLabel(label: 'GST Number'),
            TextInputField(
              controller: controller.gstCtrl,
              hintText: '15-character GST number',
              maxLength: 15,
            ),
            Gap(10.h),
            RequiredLabel(label: 'PAN Number'),
            TextInputField(
              controller: controller.panCtrl,
              hintText: 'e.g. ABCDE1234F',
              maxLength: 10,
            ),
            Gap(10.h),
            RequiredLabel(label: 'CIN Number'),
            TextInputField(
              controller: controller.cinCtrl,
              hintText: 'Company Identification Number (optional)',
            ),
            Gap(10.h),
            RequiredLabel(label: 'Registration Type'),
            Gap(4.h),
            _RegistrationTypePicker(
              ctrl: controller.regTypeCtrl,
              types: _registrationTypes,
            ),
            Gap(10.h),
            RequiredLabel(label: 'Established Year'),
            TextInputField(
              controller: controller.establishedYearCtrl,
              hintText: 'e.g. 2010',
              keyboardType: TextInputType.number,
              maxLength: 4,
            ),
            Obx(
              () => PrimaryButton(
                label: 'SUBMIT LEGAL DETAILS',
                onPressed: controller.isSavingLegal.value
                    ? null
                    : controller.submitLegal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegistrationTypePicker extends StatefulWidget {
  final TextEditingController ctrl;
  final List<String> types;
  const _RegistrationTypePicker({required this.ctrl, required this.types});

  @override
  State<_RegistrationTypePicker> createState() =>
      _RegistrationTypePickerState();
}

class _RegistrationTypePickerState extends State<_RegistrationTypePicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.types.map((t) {
          final isSelected = widget.ctrl.text == t;

          return ChoiceChip(
            label: Text(t),
            selected: isSelected,
            selectedColor: bohibaTheme.primaryColor,
            backgroundColor: bohibaTheme.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            labelStyle: TextStyle(
              color: isSelected
                  ? bohibaTheme.textTheme.displayLarge?.color
                  : bohibaTheme.textTheme.labelLarge?.color,
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            onSelected: (_) {
              setState(() {
                widget.ctrl.text = t;
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
