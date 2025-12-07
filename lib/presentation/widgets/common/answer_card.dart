import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/chat_message.dart';
class AnswerCard extends StatelessWidget {
  const AnswerCard({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Avatar صغير في الأعلى
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: AssetImage('assets/images/bubble.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // المحتوى بدون خلفية
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم المساعد
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Qanouny Assistant',
                    style: AppStyles.styleSemitBold14.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ),
                
                // المحتوى الأساسي
                _MarkdownContent(text: message.content),
                
                const SizedBox(height: 8),
                
                // Risk Level
                if (message.riskLevel != null && message.riskLevel!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '⚠️ Risk Level: ${message.riskLevel![0].toUpperCase()}${message.riskLevel!.substring(1)}',
                      style: AppStyles.styleRegular14.copyWith(
                        color: _getRiskColor(message.riskLevel!),
                      ),
                    ),
                  ),
                
                // Full Text إذا موجود
                if (message.fullText?.isNotEmpty ?? false) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📄 Extracted Text:',
                          style: AppStyles.styleSemitBold14.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message.fullText!,
                          style: AppStyles.styleRegular14.copyWith(
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Term Summary إذا موجود
                if (message.termSummary?.isNotEmpty ?? false) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📋 Term Summary:',
                          style: AppStyles.styleSemitBold14.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _MarkdownContent(text: message.termSummary!),
                      ],
                    ),
                  ),
                ],
                
                // Cited Sources إذا موجود
                if (message.citedSources.isNotEmpty) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🔗 Cited Sources:',
                          style: AppStyles.styleSemitBold14.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ...message.citedSources.map((source) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (source.category?.isNotEmpty ?? false)
                                  Text(
                                    '📁 ${source.category!}',
                                    style: AppStyles.styleSemitBold14.copyWith(
                                      color: Colors.blue[300],
                                    ),
                                  ),
                                const SizedBox(height: 2),
                                _MarkdownContent(text: source.text),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'red':
        return Colors.red[400]!;
      case 'amber':
        return Colors.orange[400]!;
      case 'green':
        return Colors.green[400]!;
      default:
        return Colors.purple[400]!;
    }
  }
}

class _MarkdownContent extends StatelessWidget {
  const _MarkdownContent({required this.text});

  final String text;
  static final _rtlPattern = RegExp(r'[\u0600-\u06FF]');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final direction = _detectDirection(text);

    return SizedBox(
      width: double.infinity,
      child: Directionality(
        textDirection: direction,
        child: MarkdownBody(
          data: text,
          shrinkWrap: true,
          selectable: true,
          softLineBreak: true,
          styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
            p: AppStyles.styleRegular16.copyWith(
              color: Colors.white,
              height: 1.5,
            ),
            h1: AppStyles.styleSemitBold16.copyWith(color: Colors.white),
            h2: AppStyles.styleSemitBold14.copyWith(
              fontSize: 15,
              color: Colors.white,
            ),
            h3: AppStyles.styleSemitBold14.copyWith(color: Colors.white),
            strong: AppStyles.styleRegular16.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            listBullet: AppStyles.styleRegular16.copyWith(color: Colors.white),
            blockquote: AppStyles.styleRegular16.copyWith(
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
            a: AppStyles.styleRegular16.copyWith(
              color: Colors.blue[300],
              decoration: TextDecoration.underline,
            ),
            code: AppStyles.styleRegular16.copyWith(
              backgroundColor: Colors.transparent,
              color: Colors.yellow[300],
            ),
            codeblockDecoration: BoxDecoration(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  static TextDirection _detectDirection(String value) {
    if (value.isEmpty) return TextDirection.ltr;
    return _rtlPattern.hasMatch(value) ? TextDirection.rtl : TextDirection.ltr;
  }
}