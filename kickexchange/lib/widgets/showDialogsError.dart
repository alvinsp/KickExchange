import 'package:flutter/material.dart';
import 'package:kickexchange/core/preferences/colors.dart';

void showDialogsError(BuildContext context, Widget content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: AlertDialog(
            content: content,
            actions: <Widget>[
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(AppColors.red),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
