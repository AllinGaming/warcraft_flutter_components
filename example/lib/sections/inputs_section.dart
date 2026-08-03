import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

/// Showcases [WarcraftInput] and [WarcraftTextarea], including disabled
/// instances of each.
class InputsSection extends StatelessWidget {
  const InputsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WarcraftInput(
          hintText: 'Enter your name...',
          maxWidth: 420,
        ),
        const SizedBox(height: 12),
        const WarcraftInput(
          hintText: 'Disabled input',
          enabled: false,
          maxWidth: 420,
        ),
        const SizedBox(height: 16),
        const WarcraftTextarea(
          hintText: 'Your quest details',
          maxWidth: 420,
        ),
        const SizedBox(height: 12),
        const WarcraftTextarea(
          hintText: 'Disabled textarea',
          enabled: false,
          maxWidth: 420,
        ),
      ],
    );
  }
}
