import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '/component/app_skeleton_loader.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/screen_utils.dart';
import '/controllers/bank_account_controller.dart';
import '/model/bank_account_model.dart';
import '/theme/bohiba_theme.dart';

class BankAccountsScreen extends GetView<BankAccountController> {
  const BankAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleAppbar(title: 'Bank Accounts'),
      body: Obx(() {
        if (controller.isLoading.value) return const _BankAccountSkeleton();
        if (controller.accounts.isEmpty) {
          return _EmptyState(controller: controller);
        }
        return _AccountList(controller: controller);
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value) return const SizedBox.shrink();
        return _AddAccountBar(controller: controller);
      }),
    );
  }
}

// ─── Account list ────────────────────────────────────────────────────────────

class _AccountList extends StatelessWidget {
  final BankAccountController controller;
  const _AccountList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.height15, vertical: ScreenUtils.height15),
      itemCount: controller.accounts.length,
      itemBuilder: (context, i) =>
          _AccountCard(account: controller.accounts[i], controller: controller),
    );
  }
}

// ─── Single account card ─────────────────────────────────────────────────────

class _AccountCard extends StatelessWidget {
  final BankAccountModel account;
  final BankAccountController controller;
  const _AccountCard({required this.account, required this.controller});

  @override
  Widget build(BuildContext context) {
    final color = account.isPrimary
        ? bohibaTheme.primaryColor
        : bohibaTheme.colorScheme.onSurface;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: bohibaTheme.canvasColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: account.isPrimary
              ? bohibaTheme.primaryColor.withValues(alpha: 0.9)
              : bohibaTheme.dividerColor,
          width: account.isPrimary ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: bohibaTheme.dividerColor.withValues(alpha: 0.9),
            blurRadius: account.isPrimary ? 8 : 0,
            offset: account.isPrimary ? const Offset(0, 2) : Offset.zero,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Remix.bank_line, size: 18.sp, color: color),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    account.bankName ?? '—',
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                      fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                      color: bohibaTheme.textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
                if (account.isPrimary)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: bohibaTheme.colorScheme.onPrimary
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Primary',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: bohibaTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            // Masked account number
            _InfoRow(
              label: 'Account No.',
              value: account.accountNumber ?? '',
            ),
            _InfoRow(
              label: 'IFSC Code',
              value: account.ifscCode ?? '—',
            ),
            _InfoRow(
              label: 'Holder Name',
              value: account.holderName ?? '—',
            ),
            // 30-day lock notice
            if (!account.canEdit) ...[
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: bohibaTheme.colorScheme.error.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  children: [
                    Icon(Remix.time_line,
                        size: 14.sp, color: bohibaTheme.colorScheme.error),
                    SizedBox(width: 6.w),
                    Text(
                      'Editable in ${account.daysUntilEditable} day${account.daysUntilEditable == 1 ? '' : 's'}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: bohibaTheme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 12.h),
            // Action row
            Row(
              children: [
                if (!account.isPrimary)
                  _ActionChip(
                    label: 'Set Primary',
                    icon: Remix.star_line,
                    color: bohibaTheme.primaryColor,
                    onTap: () => controller.setPrimary(account),
                  ),
                if (!account.isPrimary) SizedBox(width: 8.w),
                _ActionChip(
                  label: 'Edit',
                  icon: Remix.pencil_line,
                  color: account.canEdit
                      ? bohibaTheme.colorScheme.secondary
                      : bohibaTheme.colorScheme.onSurface
                          .withValues(alpha: 0.9),
                  onTap: account.canEdit
                      ? () => _showAccountSheet(context, controller,
                          account: account)
                      : null,
                ),
                const Spacer(),
                _ActionChip(
                  label: 'Delete',
                  icon: Remix.delete_bin_line,
                  color: bohibaTheme.colorScheme.tertiary,
                  onTap: () => _confirmDelete(context, controller, account),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          SizedBox(
            width: 90.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                color: bohibaTheme.textTheme.titleMedium!.color,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
              fontWeight: FontWeight.w600,
              color: bohibaTheme.textTheme.bodyLarge!.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  const _ActionChip(
      {required this.label,
      required this.icon,
      required this.color,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: onTap != null ? 0.10 : 0.05),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13.sp, color: color),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final BankAccountController controller;
  const _EmptyState({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Remix.bank_line,
              size: 56.sp,
              color: bohibaTheme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: 16.h),
            Text(
              'No bank accounts added',
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                color: bohibaTheme.textTheme.titleMedium!.color,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Add up to 2 bank accounts for withdrawals',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                color: (bohibaTheme.textTheme.titleMedium!.color ??
                        bohibaTheme.colorScheme.onSurface)
                    .withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddAccountBar extends StatelessWidget {
  final BankAccountController controller;
  const _AddAccountBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool limitReached = !controller.canAddMore;
    final bool locked = !controller.canAddOrEdit;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.height15, vertical: 12.h),
        child: PrimaryButton(
          label: limitReached
              ? 'Maximum 2 accounts allowed'
              : locked
                  ? 'Account locked — edit cooldown active'
                  : 'Add Bank Account',
          onPressed: limitReached || locked
              ? null
              : () => _showAccountSheet(context, controller),
        ),
      ),
    );
  }
}

void _showAccountSheet(
  BuildContext context,
  BankAccountController controller, {
  BankAccountModel? account,
}) {
  final isEdit = account != null;
  if (isEdit) controller.populateFormForEdit(account);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: bohibaTheme.scaffoldBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (_) => _AccountFormSheet(
      controller: controller,
      editAccount: account,
    ),
  ).then((_) => controller.clearForm());
}

class _AccountFormSheet extends StatelessWidget {
  final BankAccountController controller;
  final BankAccountModel? editAccount;
  const _AccountFormSheet(
      {required this.controller, required this.editAccount});

  @override
  Widget build(BuildContext context) {
    final isEdit = editAccount != null;
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20.h,
      ),
      child: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: bohibaTheme.dividerColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                isEdit ? 'Edit Bank Account' : 'Add Bank Account',
                style: bohibaTheme.textTheme.headlineMedium,
              ),
              SizedBox(height: 4.h),
              Text(
                'This account will be used for withdrawals. '
                'After saving, you can edit again after 30 days.',
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                  color: bohibaTheme.textTheme.titleMedium!.color,
                ),
              ),
              SizedBox(height: 20.h),
              _FormField(
                controller: controller.holderNameCtrl,
                label: 'Account Holder Name',
                hint: 'As per bank records',
                icon: Remix.user_line,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              _FormField(
                controller: controller.bankNameCtrl,
                label: 'Bank Name',
                hint: 'e.g. State Bank of India',
                icon: Remix.bank_line,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              _FormField(
                controller: controller.accountNumberCtrl,
                label: 'Account Number',
                hint: 'Enter account number',
                icon: Remix.hashtag,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (v.length < 9 || v.length > 18) {
                    return 'Must be 9–18 digits';
                  }
                  return null;
                },
                // Never show account number in logs or analytics — it's PII.
                obscureText: false,
              ),
              _FormField(
                controller: controller.confirmAccountCtrl,
                label: 'Confirm Account Number',
                hint: 'Re-enter account number',
                icon: Remix.hashtag,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v != controller.accountNumberCtrl.text) {
                    return 'Account numbers do not match';
                  }
                  return null;
                },
              ),
              _FormField(
                controller: controller.ifscCtrl,
                label: 'IFSC Code',
                hint: 'e.g. SBIN0001234',
                icon: Remix.global_line,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$')
                      .hasMatch(v.trim().toUpperCase())) {
                    return 'Invalid IFSC code';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              PrimaryButton(
                label: isEdit ? 'Save Changes' : 'Add Account',
                onPressed: () {
                  if (isEdit && editAccount?.id != null) {
                    controller.submitEdit(editAccount!.id!);
                  } else {
                    controller.submitAdd();
                  }
                },
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool obscureText;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.words,
    this.inputFormatters,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        validator: validator,
        style: TextStyle(
          fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
          color: bohibaTheme.textTheme.bodyLarge!.color,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, size: 18.sp),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        ),
      ),
    );
  }
}

void _confirmDelete(
  BuildContext context,
  BankAccountController controller,
  BankAccountModel account,
) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete Account?'),
      content: Text(
        'Remove ${account.accountNumber} (${account.bankName ?? 'this account'})? '
        'This cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            controller.deleteAccount(account);
          },
          child: Text(
            'Delete',
            style: TextStyle(color: bohibaTheme.colorScheme.error),
          ),
        ),
      ],
    ),
  );
}

class _BankAccountSkeleton extends StatelessWidget {
  const _BankAccountSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ScreenUtils.height15),
      child: Column(
        children: [
          AppSkeletonLoader(
              height: 160.h, borderRadius: BorderRadius.circular(12.r)),
          SizedBox(height: 14.h),
          AppSkeletonLoader(
              height: 160.h, borderRadius: BorderRadius.circular(12.r)),
        ],
      ),
    );
  }
}
