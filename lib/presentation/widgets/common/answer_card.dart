import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
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
                Row(
                  children: [
                    Text(
                      'Qanouny Assistant',
                      style: AppStyles.styleSemitBold14,
                    ),
                    const SizedBox(width: 8),
                    _RiskChip(riskLevel: message.riskLevel),
                    const SizedBox(width: 8),
                    _KindChip(kind: message.kind),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  message.content,
                  style: AppStyles.styleRegular16.copyWith(
                    height: 1.4,
                  ),
                ),
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
                if (message.sources.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Sources',
                    style: AppStyles.styleSemitBold14,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: message.sources
                        .map(
                          (source) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              source,
                              style: AppStyles.styleRegular14,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
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

