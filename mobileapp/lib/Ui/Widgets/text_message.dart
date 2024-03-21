
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final DocumentSnapshot message;

  @override
  Widget build(BuildContext context) {
    return AdjustableContainer(message: message);
  }
}

class AdjustableContainer extends StatelessWidget {
  const AdjustableContainer({
    Key? key,
    required this.message,
  }) : super(key: key);

  final DocumentSnapshot<Object?> message;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 70
            .w, // Set the maximum width of the container (70% of screen width)
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.4.h, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent[200]!
              .withOpacity(message.get('isSender') ? 0.80 : 0.1),
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: Wrap(
          alignment: WrapAlignment.start,
          children: [
            Text(
              message.get('message'),
              // ignore: deprecated_member_use
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: message.get('isSender')
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
