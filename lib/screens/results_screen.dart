import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../services/decision_service.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = Provider.of<DecisionService>(context).currentResult;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analysis Results'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pros/Cons'),
              Tab(text: 'Comparison'),
              Tab(text: 'SWOT'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCard(result!.prosAndCons),
            _buildCard(result.comparisonTable),
            _buildCard(result.swotAnalysis),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String data) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: const Color(0xFFFFF1EC), // 🍑 same peach color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Markdown(
            data: data,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(
                color: Colors.black87, // ✅ darker text
              ),
              h1: const TextStyle(
                color: Colors.deepPurple,
              ),
              h2: const TextStyle(
                color: Colors.deepPurple,
              ),
              h3: const TextStyle(
                color: Colors.deepPurple,
              ),
              strong: const TextStyle(
                color: Colors.black,
              ),
              listBullet: const TextStyle(
                color: Colors.deepPurple,
              ),
              tableHead: const TextStyle(
                color: Colors.white,
              ),
              tableBody: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}