import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/features/chat/presentation/widgets/chat_message.dart';

class AnswerCard extends StatefulWidget {
  const AnswerCard({super.key, required this.message});
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('Qanouny Assistant',
                      style: AppStyles.styleSemitBold14
                          .copyWith(color: Colors.white70)),
                ),
                _MarkdownContent(text: widget.message.content),
                const SizedBox(height: 8),
                if (widget.message.riskLevel?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '⚠️ Risk Level: ${_capitalize(widget.message.riskLevel!)}',
                      style: AppStyles.styleRegular14.copyWith(
                          color: _riskColor(widget.message.riskLevel!)),
                    ),
                  ),
                if (widget.message.fullText?.isNotEmpty ?? false) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('📄 Extracted Text:',
                            style: AppStyles.styleSemitBold14
                                .copyWith(color: Colors.white70)),
                        const SizedBox(height: 4),
                        Text(widget.message.fullText!,
                            style: AppStyles.styleRegular14.copyWith(
                                color: Colors.white70, height: 1.4)),
                      ],
                    ),
                  ),
                ],
                if (widget.message.termSummary?.isNotEmpty ?? false)
                  _ExpandableSection(
                    label: '📋 Term Summary',
                    isOpen: _showSummary,
                    onToggle: () =>
                        setState(() => _showSummary = !_showSummary),
                    child:
                        _MarkdownContent(text: widget.message.termSummary!),
                  ),
                if (widget.message.citedSources.isNotEmpty)
                  _ExpandableSection(
                    label:
                        '🔗 Cited Sources (${widget.message.citedSources.length})',
                    isOpen: _showSources,
                    onToggle: () =>
                        setState(() => _showSources = !_showSources),
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
                              if (source.category?.isNotEmpty ?? false) ...[
                                Row(
                                  children: [
                                    const Icon(Icons.folder,
                                        color: Colors.red, size: 16),
                                    const SizedBox(width: 4),
                                    Text(source.category!,
                                        style: AppStyles.styleSemitBold14
                                            .copyWith(color: Colors.red)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                              ],
                              _MarkdownContent(text: source.text),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  Color _riskColor(String risk) {
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

class _ExpandableSection extends StatelessWidget {
  const _ExpandableSection({
    required this.label,
    required this.isOpen,
    required this.onToggle,
    required this.child,
  });

  final String label;
  final bool isOpen;
  final VoidCallback onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[700]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isOpen ? Icons.expand_less : Icons.expand_more,
                        color: Colors.white70,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(label,
                          style: AppStyles.styleSemitBold14
                              .copyWith(color: Colors.white70)),
                    ],
                  ),
                  Icon(
                    isOpen ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white70,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          if (isOpen) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[700]!),
              ),
              child: child,
            ),
          ],
        ],
      ),
    );
  }
}

class _MarkdownContent extends StatelessWidget {
  const _MarkdownContent({required this.text});

  final String text;
  static final _rtlPattern = RegExp(r'[؀-ۿ]');

  @override
  Widget build(BuildContext context) {
    final direction =
        _rtlPattern.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
    return SizedBox(
      width: double.infinity,
      child: Directionality(
        textDirection: direction,
        child: MarkdownBody(
          data: text,
          shrinkWrap: true,
          selectable: true,
          softLineBreak: true,
          styleSheet:
              MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            p: AppStyles.styleRegular16
                .copyWith(color: Colors.white, height: 1.5),
            h1: AppStyles.styleSemitBold16.copyWith(color: Colors.white),
            h2: AppStyles.styleSemitBold14
                .copyWith(fontSize: 15, color: Colors.white),
            h3: AppStyles.styleSemitBold14.copyWith(color: Colors.white),
            strong: AppStyles.styleRegular16.copyWith(
                color: Colors.white, fontWeight: FontWeight.w700),
            listBullet:
                AppStyles.styleRegular16.copyWith(color: Colors.white),
            blockquote: AppStyles.styleRegular16.copyWith(
                color: Colors.white70, fontStyle: FontStyle.italic),
            a: AppStyles.styleRegular16.copyWith(
                color: Colors.blue[300],
                decoration: TextDecoration.underline),
            code: AppStyles.styleRegular16.copyWith(
                backgroundColor: Colors.transparent,
                color: Colors.yellow[300]),
            codeblockDecoration:
                const BoxDecoration(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
