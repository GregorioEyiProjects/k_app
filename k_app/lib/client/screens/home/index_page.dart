import 'package:flutter/material.dart';
import 'package:k_app/client/screen-components/home/v2/customBottomNav2.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          children: [
            // HomeScreen(),
            // BillingScreen(),
          ],
        ),
        bottomNavigationBar: CustomBottomNav2(),
      ),
    );
  }
}
