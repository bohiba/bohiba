import 'package:flutter/material.dart';

class VehicleDocuments extends StatelessWidget {
  final String vehicleDocument;
  final String expiryDate;
  final VoidCallback? onPressed;
  final Widget? trailing;
  const VehicleDocuments({
    Key? key,
    this.vehicleDocument = "Document Name",
    this.expiryDate = "expiryDate",
    this.onPressed,
    this.trailing = const SizedBox(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(vehicleDocument),
        titleTextStyle: Theme.of(context).textTheme.titleSmall,
        subtitle: Text(expiryDate),
        subtitleTextStyle: Theme.of(context).textTheme.labelMedium,
        trailing: trailing
    );
  }
}