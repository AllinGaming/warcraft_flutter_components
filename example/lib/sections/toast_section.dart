import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

/// Showcases [WarcraftToast.show], one button per [WarcraftToastType] and
/// one per [WarcraftToastPosition]. Each `onPressed` uses its own build-scope
/// `context`, which is still mounted in the app's widget tree and can find
/// the enclosing `Overlay`.
class ToastSection extends StatelessWidget {
  const ToastSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('By type', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final type in WarcraftToastType.values)
              WarcraftButton(
                size: WarcraftButtonSize.sm,
                onPressed: () => WarcraftToast.show(
                  context,
                  message: 'This is a ${type.name} toast.',
                  type: type,
                ),
                child: Text(type.name),
              ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('By position', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final position in WarcraftToastPosition.values)
              WarcraftButton(
                size: WarcraftButtonSize.sm,
                variant: WarcraftButtonVariant.frame,
                onPressed: () => WarcraftToast.show(
                  context,
                  message: 'Toast at ${position.name}.',
                  position: position,
                ),
                child: Text(position.name),
              ),
          ],
        ),
      ],
    );
  }
}
