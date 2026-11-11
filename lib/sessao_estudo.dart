class SessaoEstudo {
  final int? id;
  final String tema;
  final int minutos;
  final String observacao;

  const SessaoEstudo({
    this.id,
    required this.tema,
    required this.minutos,
    required this.observacao,
  });

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'tema': tema,
      'minutos': minutos,
      'observacao': observacao,
    };
  }

  factory SessaoEstudo.fromMap(Map<String, Object?> mapa) {
    return SessaoEstudo(
      id: mapa['id'] as int,
      tema: mapa['tema'] as String,
      minutos: mapa['minutos'] as int,
      observacao: mapa['observacao'] as String,
    );
  }
}
