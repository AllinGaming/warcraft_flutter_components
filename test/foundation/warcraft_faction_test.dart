import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftFactionName.label', () {
    test('returns the lowercase name for every faction', () {
      expect(WarcraftFaction.defaultFaction.label, 'default');
      expect(WarcraftFaction.orc.label, 'orc');
      expect(WarcraftFaction.elf.label, 'elf');
      expect(WarcraftFaction.human.label, 'human');
      expect(WarcraftFaction.undead.label, 'undead');
    });
  });
}
