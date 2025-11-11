import 'package:flutter/material.dart';
import 'package:kms/src/utils/app_const.dart';
import 'package:kms/src/widgets/app_container.dart';
import 'package:kms/src/widgets/app_material.dart';
import 'package:kms/src/widgets/app_text.dart';
import 'package:kms/src/widgets/loanCalculatorDialog.dart';

class LoanCards extends StatefulWidget {
  const LoanCards({super.key});

  @override
  State<LoanCards> createState() => _LoanCardsState();
}

class _LoanCardsState extends State<LoanCards> {
  void _showLoanCalculator() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoanCalculatorPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppMaterial(
              color: AppConst.grey400,
              elevation: 5,
              radius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: AppMaterial(
                  color: AppConst.grey300,
                  elevation: 20,
                  radius: BorderRadius.circular(10),
                  child: AppContainer(
                    child: Column(
                      children: [
                        ListTile(
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () => _showLoanCalculator(),
                                    icon: Icon(Icons.calculate)),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.card_travel_outlined))
                              ],
                            ),
                          ),
                          title: AppText(
                            txt: 'Current Loan',
                            size: 15,
                            color: AppConst.black,
                            weight: FontWeight.w400,
                          ),
                          subtitle: AppText(
                            txt: '14,190,089.58',
                            size: 20,
                            color: AppConst.primary,
                            weight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    bottom: 10,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
