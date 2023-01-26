import 'package:flutter/material.dart';
import 'package:fyp1/shared/appcolors.dart';

class ItemITP {
  final num index;
  final String question;
  final String answer;
  final String trait;
  String selectedAnswer;

  ItemITP(
      {required this.index,
      required this.question,
      required this.answer,
      required this.trait,
      required this.selectedAnswer});
}

class ItemIMK {
  final num index;
  final String question;
  final String type;
  String selectedAnswer;

  ItemIMK(
      {required this.index,
      required this.question,
      required this.type,
      required this.selectedAnswer});
}

class Option extends StatelessWidget {
  final String value;
  // final bool isSelected;
  final OptionTheme? theme;
  final String selectedAnswer;
  final VoidCallback onTap;

  const Option(
      {Key? key,
      required this.value,
      // required this.isSelected,
      this.theme,
      required this.selectedAnswer,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Theme(
        data: ThemeData(
          splashColor: Colors.white,
          highlightColor: AppColors.primary.withOpacity(0.8),
        ),
        child: OutlinedButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return AppColors.option.withOpacity(0.5);
                }
                return null;
              }),
              backgroundColor: MaterialStateProperty.all(
                selectedAnswer == value ? theme!.backgroundColor! : null,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              side: MaterialStateProperty.all(
                BorderSide(
                    color: selectedAnswer == value
                        ? theme!.backgroundColor!
                        : AppColors.gray.withOpacity(0.15)),
              ),
              minimumSize:
                  MaterialStateProperty.all(const Size(double.infinity, 44)),
            ),
            onPressed: onTap,
            child: Row(
              children: [
                Icon(
                  selectedAnswer == value ? theme!.icon ?? Icons.circle : null,
                  color: Colors.white,
                ),
                const SizedBox(width: 8.0),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: selectedAnswer == value
                          ? Colors.white
                          : AppColors.text2),
                ),
              ],
            )),
      ),
    );
  }
}

class OptionTheme {
  final Color? borderColor;
  final Color? backgroundColor;
  final IconData? icon;

  OptionTheme({this.borderColor, this.backgroundColor, this.icon});
}

// OutlinedButton.styleFrom(
//   backgroundColor:
//       selectedAnswer == value ? theme!.backgroundColor! : null,
//   shape: RoundedRectangleBorder(
//     borderRadius: BorderRadius.circular(12.0),
//   ),
//   side: BorderSide(
//       color: selectedAnswer == value
//           ? theme!.backgroundColor!
//           : AppColors.gray.withOpacity(0.15)),
//   minimumSize: const Size(double.infinity, 44)),