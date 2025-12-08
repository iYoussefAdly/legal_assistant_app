import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/chat_message.dart';

class AnswerCard extends StatefulWidget {
  const AnswerCard({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  @override
  State<AnswerCard> createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  bool _showSources = false;
  bool _showSummary = false;

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
                _MarkdownContent(text: widget.message.content),
                
                const SizedBox(height: 8),
                
                // Risk Level
                if (widget.message.riskLevel != null && widget.message.riskLevel!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '⚠️ Risk Level: ${widget.message.riskLevel![0].toUpperCase()}${widget.message.riskLevel!.substring(1)}',
                      style: AppStyles.styleRegular14.copyWith(
                        color: _getRiskColor(widget.message.riskLevel!),
                      ),
                    ),
                  ),
                
                // Full Text إذا موجود
                if (widget.message.fullText?.isNotEmpty ?? false) ...[
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
                          widget.message.fullText!,
                          style: AppStyles.styleRegular14.copyWith(
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Term Summary Dropdown إذا موجود
                if (widget.message.termSummary?.isNotEmpty ?? false) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dropdown Header
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showSummary = !_showSummary;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey[700]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _showSummary 
                                          ? Icons.expand_less 
                                          : Icons.expand_more,
                                      color: Colors.white70,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '📋 Term Summary',
                                      style: AppStyles.styleSemitBold14.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  _showSummary
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Dropdown Content
                        if (_showSummary) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey[700]!,
                                width: 1,
                              ),
                            ),
                            child: _MarkdownContent(text: widget.message.termSummary!),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                
                // Cited Sources Dropdown إذا موجود
                if (widget.message.citedSources.isNotEmpty) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dropdown Header
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showSources = !_showSources;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey[700]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _showSources 
                                          ? Icons.expand_less 
                                          : Icons.expand_more,
                                      color: Colors.white70,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '🔗 Cited Sources (${widget.message.citedSources.length})',
                                      style: AppStyles.styleSemitBold14.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  _showSources
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Dropdown Content
                        if (_showSources) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey[700]!,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.message.citedSources.map((source) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (source.category?.isNotEmpty ?? false)
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.folder,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              source.category!,
                                              style: AppStyles.styleSemitBold14.copyWith(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (source.category?.isNotEmpty ?? false)
                                        const SizedBox(height: 4),
                                      _MarkdownContent(text: source.text),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
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