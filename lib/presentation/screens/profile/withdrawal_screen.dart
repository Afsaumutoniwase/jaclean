import 'package:flutter/material.dart';
import '../../widgets/custom_elevated_btn.dart';
import '../../widgets/custom_full_elevated_btn.dart';
import '../../widgets/custom_title.dart';
import 'withdrawal_success.dart';
class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {

  String amount = "50,046.00";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Withdraw"),),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            const CustomTitle(title: "Withdrawal Methods"),

            Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Access Bank', style: TextStyle(fontSize: 16),),
                  const SizedBox(height: 5,),
                  const Text('3399329933', style: TextStyle(fontSize: 16),),
                  const SizedBox(height: 5,),
                  const Text('Simeon Azeh', style: TextStyle(fontSize: 16),),
                  const SizedBox(height: 5),
                  CustomElevatedBtn(
                      onPressed: (){},
                      text: "Change Bank"),
                  const SizedBox(height: 10,),
                  const Text(
                      "Amount",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                  ),
                  const TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter Amount",
                      prefixText: "₦ ",
                    ),
                  ),
                  const SizedBox(height:8,),
                  Container(
                    padding: EdgeInsets.all(10),

                    child: const Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('10% (App Fee)'),
                            Text('₦0.00'),
                          ],

                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TOTAL",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "₦0.00"
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12,),
                  CustomFullElevatedBtn(onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WithdrawalSuccess() )
                    );
                  }, text: "Withdraw")

                ],


              ),
            )
          ],
        ),

      ),
    );


  }
}

