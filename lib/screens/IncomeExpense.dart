
import 'package:flutter/material.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/screens/customerretrivehover.dart';
import 'package:truckclgproject/screens/supplierretrievehover.dart';
import 'package:truckclgproject/widgets/customcolorappbar.dart';

class IncomeExpense extends StatefulWidget {
  const IncomeExpense({super.key});

  @override
  State<IncomeExpense> createState() => _IncomeExpenseState();
}

class _IncomeExpenseState extends State<IncomeExpense> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarcolor(
        height: 120,
        title: '',
        child: Column(
          children: [
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTextButton("Customer", 0),
                _buildTextButton("Supplier", 1),
              ],
            ),
          ],
        ),
      ),
      // Replace Expanded with a Column or Container
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: const [
                CustomerRetriveHover(),
                Supplierretrievehover(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextButton(String text, int page) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          page,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedDefaultTextStyle(
        style: TextStyle(
          fontSize: 20,
          color: _currentPage == page ? Colors.blue : Colors.black,
          decoration: _currentPage == page
              ? TextDecoration.underline
              : TextDecoration.none,
        ),
        duration: const Duration(milliseconds: 300),
        child: Text(
          text,
          style: TextStyle(fontSize: 22, color: white),
        ),
      ),
    );
  }
}
