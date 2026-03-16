import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'app_tab.dart';

class TabNavigationWidget extends StatefulWidget {
  final List<AppTab> tabs;

  const TabNavigationWidget({super.key, required this.tabs});

  @override
  State<TabNavigationWidget> createState() => _TabNavigationWidgetState();
}

class _TabNavigationWidgetState extends State<TabNavigationWidget>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: widget.tabs.map((tab) => tab.page).toList(),
      ),

      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react, // faz com que o ícone cresça quando selecionado
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).primaryColor,
        controller: tabController,
        items: widget.tabs
            .map((tab) => TabItem(icon: tab.icon, title: tab.title))
            .toList(),
        onTap: (index) {
          tabController.animateTo(index);
        },
      ),
    );
  }
}
