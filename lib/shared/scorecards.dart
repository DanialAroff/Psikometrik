import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'string_extension.dart';

class ScoreCard extends StatelessWidget {
  final DocumentSnapshot scores;
  final String title;
  final bool sort;
  final List<String>? construct;
  const ScoreCard(
      {Key? key,
      required this.scores,
      this.title = 'Inventori',
      this.sort = false,
      this.construct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3)),
      ], borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: const EdgeInsets.all(14),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              domainRows(),
            ],
          ),
        ),
      ),
    );
  }

  Widget domainRows() {
    Map<String, dynamic> data = scores.data() as Map<String, dynamic>;
    List domains = data.keys.toList();

    if (sort) {
      domains.sort();
    }

    List<Widget> list = [];
    // If there is a construct passed as argument then the scoring will
    // use the naming of the construct
    if (construct != null) {
      for (int el = 0; el < construct!.length; el++) {
        String c = construct![el];
        try {
          num score = data[c];
          list.add(domainPercentageBar(c.titleCase, score.toDouble()));
        } catch (e) {
          debugPrint('scorecards.dart@domainRows() - $e');
          list.add(const Text('##'));
        }
        if (el != construct!.length -1 ) {  
          list.add(const SizedBox(height: 8.0));
          list.add(Divider(
            thickness: 1.0,
            height: 3.0,
            color: Colors.grey.withOpacity(0.15),
          ));
        }
      }
    } else {
      for (int el = 0; el < domains.length; el++) {
        dynamic element = domains[el];
        String domainName = element.replaceAll('_', ' ');
        domainName = domainName.titleCase;
        num score = scores.get(
            element); // setting as a num make it possible to convert it to double
        list.add(domainPercentageBar(domainName, score.toDouble()));
        if (el != domains.length - 1) {
          list.add(const SizedBox(height: 8.0));
          list.add(const Divider(thickness: 1.0, height: 2.0));
        }
      }
    }

    return Column(
      children: list,
    );
  }

  Widget domainPercentageBar(String domain, double score) {
    return Column(
      children: [
        const SizedBox(height: 6.0),
        Row(
          children: [
            Text(domain),
            const Spacer(),
            Text(
              '${(score).toInt()}%',
              style: const TextStyle(fontWeight: FontWeight.w600),
            )
          ],
        ),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(12),
        //   child: LinearProgressIndicator(
        //     value: score / 100,
        //     minHeight: 16,
        //     backgroundColor: Colors.black12,
        //     valueColor:
        //         const AlwaysStoppedAnimation<Color>(AppColors.secondary),
        //   ),
        // ),
      ],
    );
  }
}
