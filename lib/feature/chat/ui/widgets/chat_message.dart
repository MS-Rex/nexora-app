import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isLoading;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    this.isLoading = false,
  });

  Future<void> _launchUrl(String url) async {
    try {
      String finalUrl = url;

      // Handle different URL schemes
      if (url.contains('@') && !url.startsWith('mailto:')) {
        finalUrl = 'mailto:$url';
      } else if (url.startsWith('www.')) {
        finalUrl = 'https://$url';
      }

      final Uri uri = Uri.parse(finalUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
      } else {
        // Try alternative launch modes
        try {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        } catch (e) {
          debugPrint('Failed to launch URL: $e');
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  String _preprocessMarkdown(String text) {
    // Auto-convert email addresses to markdown links
    final emailRegex = RegExp(
      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
    );
    String processedText = text.replaceAllMapped(emailRegex, (match) {
      final email = match.group(0)!;
      // Don't double-convert if it's already a markdown link
      if (!text.substring(0, match.start).endsWith('[') &&
          !text.substring(match.end).startsWith(']')) {
        return '[$email](mailto:$email)';
      }
      return email;
    });

    // Auto-convert URLs to markdown links
    final urlRegex = RegExp(r'https?://[^\s<>"{}|\\^`\[\]]+');
    processedText = processedText.replaceAllMapped(urlRegex, (match) {
      final url = match.group(0)!;
      // Don't double-convert if it's already a markdown link
      if (!processedText.substring(0, match.start).endsWith('[') &&
          !processedText.substring(match.end).startsWith(']')) {
        return '[$url]($url)';
      }
      return url;
    });

    return processedText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isUser
                        ? const Color.fromARGB(255, 124, 58, 237)
                        : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child:
                  isLoading
                      ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Thinking',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 124, 58, 237),
                              ),
                            ),
                          ),
                        ],
                      )
                      : isUser
                      ? Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        softWrap: true,
                      )
                      : MarkdownBody(
                        data: _preprocessMarkdown(text),
                        onTapLink: (text, href, title) {
                          if (href != null && href.isNotEmpty) {
                            _launchUrl(href);
                          } else if (text != null && text.contains('@')) {
                            // Fallback: if href is null but text contains @, treat as email
                            _launchUrl(text);
                          }
                        },
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            height: 1.4,
                          ),
                          h1: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          h2: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          h3: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          code: TextStyle(
                            backgroundColor: Colors.grey[200],
                            color: Colors.black87,
                            fontSize: 13,
                            fontFamily: 'monospace',
                          ),
                          codeblockDecoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          blockquote: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                          listBullet: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          strong: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          em: const TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                          ),
                          a: const TextStyle(
                            color: Color.fromARGB(255, 124, 58, 237),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        selectable: true,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
