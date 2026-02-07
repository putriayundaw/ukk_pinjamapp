import 'package:flutter/material.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D47A1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            Container(
              height: 35,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ToggleButtons(
                isSelected: const [true, false, false],
                onPressed: (index) {},
                borderRadius: BorderRadius.circular(20),
                selectedColor: Colors.white,
                color: Colors.grey.shade600,
                fillColor: primaryBlue,
                constraints: const BoxConstraints(
                  minHeight: 35,
                  minWidth: 60,
                ),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Today'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Weekly'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Month'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        _buildChart(),
      ],
    );
  }

  Widget _buildChart() {
    final List<double> data = [90, 95, 35, 25, 65, 20, 55];
    final List<String> days = [
      'Mon\nday',
      'Tues\nday',
      'Wednes\nday',
      'Thurs\nday',
      'Fri\nday',
      'Satur\nday',
      'Sun\nday'
    ];

    const Color primaryBlue = Color(0xFF0D47A1);
    const double barWidth = 22.0;

    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(data.length, (index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: barWidth,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    Container(
                      width: barWidth,
                      height: (data[index] / 100) * 160,
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                days[index],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          );
        }),
      ),
    );
  }
}
