import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/decision_result.dart';

class DecisionService extends ChangeNotifier {
  DecisionResult? currentResult;
  bool isLoading = false;
  String? errorMessage;

  final String _apiKey = 'API';

  Future<void> analyzeDecision(String decisionPrompt) async {
    isLoading = true;
    errorMessage = null;
    currentResult = null; // 🧹 clear old data
    notifyListeners();

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
      );

      final prompt = '''
You are an expert decision-making assistant.

The user is trying to decide: "$decisionPrompt"

STRICT RULES:
- Respond ONLY in markdown
- Use EXACTLY these 3 sections
- Do NOT add extra commentary

### Pros and Cons
Provide a clear list of advantages and disadvantages.

### Comparison Table
Provide a markdown table comparing options if applicable.

### SWOT Analysis
Provide Strengths, Weaknesses, Opportunities, Threats.
''';

      final response =
      await model.generateContent([Content.text(prompt)]);

      final text = response.text ?? '';

      if (text.isEmpty) {
        throw Exception("Empty response from AI");
      }

      currentResult = _parseResponse(text, decisionPrompt);
    } catch (e) {
      errorMessage = 'Something went wrong. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  DecisionResult _parseResponse(String text, String decision) {
    // 🧠 safer parsing using headers
    String pros = '';
    String comparison = '';
    String swot = '';

    final sections = text.split(RegExp(r'###\s*'));

    for (var section in sections) {
      if (section.toLowerCase().contains('pros and cons')) {
        pros = section;
      } else if (section.toLowerCase().contains('comparison')) {
        comparison = section;
      } else if (section.toLowerCase().contains('swot')) {
        swot = section;
      }
    }

    return DecisionResult(
      decision: decision,
      prosAndCons: pros.isNotEmpty ? pros : text,
      comparisonTable:
      comparison.isNotEmpty ? comparison : "No comparison available.",
      swotAnalysis:
      swot.isNotEmpty ? swot : "No SWOT analysis available.",
    );
  }
}
