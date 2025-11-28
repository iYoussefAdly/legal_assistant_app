import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/data/models/legal_source.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/chat_message.dart';

class AnswerCard extends StatelessWidget {
  const AnswerCard({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  static const String _avatarAsset = 'assets/images/bubble.png';

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: media.width * .12,
          height: media.width * .12,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(218, 168, 255, .4),
                Color.fromRGBO(237, 228, 247, 1),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
              width: 1.5,
            ),
            shape: BoxShape.circle,
            image: const DecorationImage(
              image: AssetImage(_avatarAsset),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: media.height * .015),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(218, 168, 255, .4),
                  Color.fromRGBO(237, 228, 247, 1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderMeta(
                  riskLevel: message.riskLevel,
                  kind: message.kind,
                ),
                const SizedBox(height: 12),
                _MarkdownContent(text: message.content),
                if (message.fullText?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Extracted text',
                    style: AppStyles.styleSemitBold14,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message.fullText!,
                    style: AppStyles.styleRegular14.copyWith(height: 1.4),
                  ),
                ],
                if (message.termSummary?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 12),
                  TermSummaryWidget(summary: message.termSummary!),
                ],
                if (message.citedSources.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  CitedSourcesWidget(sources: message.citedSources),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

}

class _HeaderMeta extends StatelessWidget {
  const _HeaderMeta({
    required this.riskLevel,
    required this.kind,
  });

  final String? riskLevel;
  final MessageKind kind;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chips = <Widget>[
      if (riskLevel != null && riskLevel!.isNotEmpty)
        FittedBox(
          child: _RiskChip(riskLevel: riskLevel),
        ),
      FittedBox(
        child: _KindChip(kind: kind),
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            'Qanouny Assistant',
            style: AppStyles.styleSemitBold14.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Align(
            alignment: AlignmentDirectional.topEnd,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.end,
              children: chips,
            ),
          ),
        ),
      ],
    );
  }
}

class _RiskChip extends StatelessWidget {
  const _RiskChip({required this.riskLevel});

  final String? riskLevel;

  @override
  Widget build(BuildContext context) {
    if (riskLevel == null || riskLevel!.isEmpty) {
      return const SizedBox.shrink();
    }
    final color = _riskColor(riskLevel!);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color),
      ),
      child: Text(
        'Risk: ${riskLevel![0].toUpperCase()}${riskLevel!.substring(1)}',
        style: AppStyles.styleRegular12.copyWith(color: color),
      ),
    );
  }

  static Color _riskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'red':
        return Colors.redAccent;
      case 'amber':
        return Colors.orangeAccent;
      case 'green':
        return Colors.green;
      default:
        return const Color(0xff6A0DAD);
    }
  }
}

class _KindChip extends StatelessWidget {
  const _KindChip({required this.kind});

  final MessageKind kind;

  @override
  Widget build(BuildContext context) {
    final label = switch (kind) {
      MessageKind.audio => 'Audio',
      MessageKind.file => 'Document',
      MessageKind.text => 'Text',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: AppStyles.styleRegular12,
      ),
    );
  }
}

class _MarkdownContent extends StatelessWidget {
  const _MarkdownContent({required this.text});

  final String text;
  static final _rtlPattern = RegExp(r'[\u0600-\u06FF]');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurface;
    final direction = _detectDirection(text);

    return SizedBox(
      width: double.infinity,
      child: Directionality(
        textDirection: direction,
        child: MarkdownBody(
          data: text,
          shrinkWrap: true,
          selectable: false,
          softLineBreak: true,
          styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
            p: AppStyles.styleRegular16.copyWith(
              color: color,
              height: 1.5,
            ),
            h1: AppStyles.styleSemitBold16.copyWith(color: color),
            h2: AppStyles.styleSemitBold14.copyWith(fontSize: 15, color: color),
            h3: AppStyles.styleSemitBold14.copyWith(color: color),
            strong: AppStyles.styleRegular16.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
            listBullet: AppStyles.styleRegular16.copyWith(color: color),
            blockquote: AppStyles.styleRegular16.copyWith(
              color: color.withValues(alpha: 0.9),
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

class TermSummaryWidget extends StatefulWidget {
  const TermSummaryWidget({super.key, required this.summary});

  final String summary;

  @override
  State<TermSummaryWidget> createState() => _TermSummaryWidgetState();
}

class _TermSummaryWidgetState extends State<TermSummaryWidget> {
  bool _expanded = false;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    return _ExpandableSection(
      label: 'Term Summary',
      expanded: _expanded,
      onPressed: _toggle,
      child: _ScrollableCard(
        child: _MarkdownContent(text: widget.summary),
      ),
    );
  }
}

class CitedSourcesWidget extends StatefulWidget {
  const CitedSourcesWidget({super.key, required this.sources});

  final List<CitedSource> sources;

  @override
  State<CitedSourcesWidget> createState() => _CitedSourcesWidgetState();
}

class _CitedSourcesWidgetState extends State<CitedSourcesWidget> {
  bool _expanded = false;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    return _ExpandableSection(
      label: 'Cited Sources',
      expanded: _expanded,
      onPressed: _toggle,
      child: _ScrollableCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final source in widget.sources) ...[
              _CitedSourceTile(source: source),
              if (source != widget.sources.last) const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExpandableSection extends StatelessWidget {
  const _ExpandableSection({
    required this.label,
    required this.expanded,
    required this.onPressed,
    required this.child,
  });

  final String label;
  final bool expanded;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fgColor = theme.colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 48,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.35),
              foregroundColor: fgColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            onPressed: onPressed,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: AppStyles.styleSemitBold14.copyWith(color: fgColor),
                  ),
                ),
                Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  color: fgColor,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: child,
          ),
          crossFadeState:
              expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }
}

class _ScrollableCard extends StatelessWidget {
  const _ScrollableCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 260),
        child: Scrollbar(
          thumbVisibility: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _CitedSourceTile extends StatelessWidget {
  const _CitedSourceTile({required this.source});

  final CitedSource source;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (source.category?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                source.category!,
                style: AppStyles.styleSemitBold14,
              ),
            ),
          _MarkdownContent(text: source.text),
        ],
      ),
    );
  }
}

