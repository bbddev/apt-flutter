import 'package:day6/widgets/StatCard.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    final cards = List.generate(
      4,
      (i) => StatCard(
        title: "Metric ${i + 1}",
        value: "${(i + 1) * 10}%",
        icon: Icons.trending_up,
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Dashboard Overview',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Expanded(
            child: isMobile
                ? ListView.separated(
                    itemCount: cards.length,
                    itemBuilder: (context, index) => cards[index],
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                  )
                : GridView.count(
                    crossAxisCount: width > 1000 ? 4 : 2,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: cards,
                  ),
          ),
        ],
      ),
    );
  }
}
