import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';

Widget MessageUser(String content) {
    return Container(
      margin: const EdgeInsets.only(right: 16, left: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xff770000).withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
                border: Border.all(
                  color: Colors.red[800]!.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                content,
                style: AppStyles.styleRegular16.copyWith(
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.blue[800],
              border: Border.all(color: Colors.blue[600]!),
            ),
            child: const Icon(
              Icons.person,
              size: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }