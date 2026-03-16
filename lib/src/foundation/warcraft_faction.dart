/// Warcraft faction variants used for styling.
enum WarcraftFaction {
  defaultFaction,
  orc,
  elf,
  human,
  undead,
}

extension WarcraftFactionName on WarcraftFaction {
  String get label {
    switch (this) {
      case WarcraftFaction.defaultFaction:
        return 'default';
      case WarcraftFaction.orc:
        return 'orc';
      case WarcraftFaction.elf:
        return 'elf';
      case WarcraftFaction.human:
        return 'human';
      case WarcraftFaction.undead:
        return 'undead';
    }
  }
}
