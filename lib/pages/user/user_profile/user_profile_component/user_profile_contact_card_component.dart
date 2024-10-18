import 'package:flutter/material.dart';

class UserProfileContactCardComponent extends StatelessWidget {
  final String header;
  final String phoneNumber;
  final String email;
  final String address;

  const UserProfileContactCardComponent({
    Key? key,
    this.header = "Header",
    this.phoneNumber = "+91- 000 000 0000",
    this.email = "your-mail@example.com",
    this.address = "City State District Pin-Code",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              header,
              maxLines: 2,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              phoneNumber,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              address,
              maxLines: 2,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}
