import 'package:flutter/material.dart';
import 'package:fyp1/shared/appcolors.dart';

// Test item model
// Consist of question, answer and domain (only for IKK)
class ItemIKK {
  final String? question;
  final String? answer;
  final String? domain;

  ItemIKK(this.question, this.answer, this.domain);

  ItemIKK.fromMap(Map data)
      : question = data['question'],
        answer = data['answer'],
        domain = data['domain'];
}

class ItemCardIKK extends StatefulWidget {
  const ItemCardIKK({
    Key? key,
    this.item,
    this.selectedAnswer,
    this.answer,
  }) : super(key: key);
  final ItemIKK? item;
  final String? selectedAnswer;
  final AnswerCallback? answer;

  @override
  State<ItemCardIKK> createState() => _ItemCardIKKState();
}

class _ItemCardIKKState extends State<ItemCardIKK>
    with AutomaticKeepAliveClientMixin {
  String? selectedAnswer;
  AnswerCallback? answer;

  @override
  void initState() {
    super.initState();
    selectedAnswer = widget.selectedAnswer;
    answer = widget.answer;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrap(
          //   children: [
            Text(
              widget.item?.question ?? '',
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.start,
            ),
          // ]),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Radio(
                value: 'Setuju',
                groupValue: selectedAnswer,
                onChanged: (String? value) {
                  setState(() => selectedAnswer = value);
                  answer!(value!);
                },
                activeColor: AppColors.primary,
                splashRadius: 12,
                visualDensity: const VisualDensity(horizontal: -4, vertical: 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0),
                child: Text(
                  'Setuju',
                  style: TextStyle(fontSize: 15),
                ),
              )
            ],
          ),
          Row(
            children: [
              Radio(
                value: 'Tidak setuju',
                groupValue: selectedAnswer,
                onChanged: (String? value) {
                  setState(() => selectedAnswer = value);
                  answer!(value!);
                },
                activeColor: AppColors.primary,
                splashRadius: 12,
                visualDensity: const VisualDensity(horizontal: -4, vertical: 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0),
                child: Text(
                  'Tidak Setuju',
                  style: TextStyle(fontSize: 15),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

typedef AnswerCallback = void Function(String value);