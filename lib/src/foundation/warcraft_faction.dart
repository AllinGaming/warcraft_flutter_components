/// Warcraft faction variants used for styling.
enum WarcraftFaction {
  /// Neutral styling not tied to any specific faction.
  defaultFaction,

  /// Horde/orcish theme, using aggressive reds and browns.
  orc,

  /// Elven theme, using cool greens and teals.
  elf,

  /// Alliance/human theme, using blues.
  human,

  /// Undead/Scourge theme, using sickly purples.
  undead,
}

/// Adds a human-readable [label] to each [WarcraftFaction] value.
extension WarcraftFactionName on WarcraftFaction {
  /// The lowercase name of this faction, e.g. `'orc'` or `'default'`.
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
