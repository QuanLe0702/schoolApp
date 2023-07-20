import 'package:flutter/material.dart';
import 'package:school/constants.dart';

class ReportCardDetailRow extends StatelessWidget {
  const ReportCardDetailRow(
      {Key? key, required this.title, required this.statusValue})
      : super(key: key);
  final String title;
  final String statusValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: kTextBlackColor, fontWeight: FontWeight.w900),
        ),
        Text(
          statusValue,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: kTextBlackColor, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}
