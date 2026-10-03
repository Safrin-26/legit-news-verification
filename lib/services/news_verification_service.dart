import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

enum VerificationStatus { genuine, fake, uncertain }

class VerificationResult {
  final VerificationStatus status;
  final String reasoning;
  final String summary;
  final double confidenceScore;
  final List<String> keyPoints;

  VerificationResult({
    required this.status,
    required this.reasoning,
    required this.summary,
    required this.confidenceScore,
    required this.keyPoints,
  });
}

class NewsVerificationService {
  final String apiKey;
  late final GenerativeModel _model;

  NewsVerificationService({required this.apiKey}) {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash-lite',
      apiKey: apiKey,
    );
  }

  /// Check if the input is a URL
  bool isUrl(String input) {
    final urlPattern = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );
    return urlPattern.hasMatch(input.trim());
  }

  /// Fetch content from a URL
  Future<String> fetchWebContent(String url) async {
    try {
      // Ensure URL has protocol
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        
        // Remove script and style elements
        document.querySelectorAll('script, style, nav, footer, header, aside').forEach((e) => e.remove());
        
        // Extract article content - try common article selectors
        final articleSelectors = ['article', '.article', '.post', '.content', 'main', '.story'];
        String? articleText;
        
        for (final selector in articleSelectors) {
          final element = document.querySelector(selector);
          if (element != null && element.text.trim().length > 200) {
            articleText = element.text;
            break;
          }
        }
        
        // Fallback to body text
        articleText ??= document.body?.text ?? '';
        
        // Clean up whitespace
        return articleText.replaceAll(RegExp(r'\s+'), ' ').trim();
      } else {
        throw Exception('Failed to fetch content: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching URL content: $e');
    }
  }

  /// Verify news content using Gemini
  Future<VerificationResult> verifyNews(String input) async {
    String contentToAnalyze;
    String inputType;

    if (isUrl(input)) {
      inputType = 'URL';
      try {
        contentToAnalyze = await fetchWebContent(input);
        if (contentToAnalyze.length > 10000) {
          contentToAnalyze = contentToAnalyze.substring(0, 10000);
        }
      } catch (e) {
        throw Exception('Could not fetch content from URL: $e');
      }
    } else {
      inputType = 'title/headline';
      contentToAnalyze = input;
    }

    final prompt = '''
You are an expert fact-checker and news verification analyst. Analyze the following news $inputType and determine if it is likely GENUINE, FAKE, or if you are UNCERTAIN.

${inputType == 'URL' ? 'Article Content' : 'News Title/Headline'}:
"""
$contentToAnalyze
"""

Provide your analysis in the following exact format:

STATUS: [GENUINE/FAKE/UNCERTAIN]
CONFIDENCE: [0-100]
SUMMARY: [A brief 1-2 sentence summary of your verdict]
REASONING: [Detailed explanation of why you reached this conclusion, considering factors like source credibility indicators, language patterns, claim verifiability, logical consistency, and any red flags or trust signals]
KEY_POINTS:
- [Key point 1]
- [Key point 2]
- [Key point 3]
- [Add more if needed]

Be thorough but concise. Focus on verifiable facts and logical analysis.
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final responseText = response.text ?? '';
      
      return _parseResponse(responseText);
    } catch (e) {
      throw Exception('Error analyzing content with AI: $e');
    }
  }

  VerificationResult _parseResponse(String response) {
    // Parse status
    VerificationStatus status = VerificationStatus.uncertain;
    final statusMatch = RegExp(r'STATUS:\s*(GENUINE|FAKE|UNCERTAIN)', caseSensitive: false).firstMatch(response);
    if (statusMatch != null) {
      switch (statusMatch.group(1)?.toUpperCase()) {
        case 'GENUINE':
          status = VerificationStatus.genuine;
          break;
        case 'FAKE':
          status = VerificationStatus.fake;
          break;
        default:
          status = VerificationStatus.uncertain;
      }
    }

    // Parse confidence
    double confidence = 50.0;
    final confidenceMatch = RegExp(r'CONFIDENCE:\s*(\d+)').firstMatch(response);
    if (confidenceMatch != null) {
      confidence = double.tryParse(confidenceMatch.group(1) ?? '50') ?? 50.0;
    }

    // Parse summary
    String summary = 'Analysis complete.';
    final summaryMatch = RegExp(r'SUMMARY:\s*(.+?)(?=REASONING:|$)', dotAll: true).firstMatch(response);
    if (summaryMatch != null) {
      summary = summaryMatch.group(1)?.trim() ?? summary;
    }

    // Parse reasoning
    String reasoning = 'No detailed reasoning available.';
    final reasoningMatch = RegExp(r'REASONING:\s*(.+?)(?=KEY_POINTS:|$)', dotAll: true).firstMatch(response);
    if (reasoningMatch != null) {
      reasoning = reasoningMatch.group(1)?.trim() ?? reasoning;
    }

    // Parse key points
    List<String> keyPoints = [];
    final keyPointsMatch = RegExp(r'KEY_POINTS:\s*(.+?)$', dotAll: true).firstMatch(response);
    if (keyPointsMatch != null) {
      final pointsText = keyPointsMatch.group(1) ?? '';
      keyPoints = pointsText
          .split('\n')
          .where((line) => line.trim().startsWith('-'))
          .map((line) => line.trim().replaceFirst(RegExp(r'^-\s*'), ''))
          .where((point) => point.isNotEmpty)
          .toList();
    }

    if (keyPoints.isEmpty) {
      keyPoints = ['Analysis completed based on available information'];
    }

    return VerificationResult(
      status: status,
      reasoning: reasoning,
      summary: summary,
      confidenceScore: confidence,
      keyPoints: keyPoints,
    );
  }
}
