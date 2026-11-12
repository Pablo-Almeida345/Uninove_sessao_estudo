import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'sessao_estudo.dart';

class BancoSessoes {
  Future<Database>? _abertura;
  Future<Database> get database async {
    try {
      _abertura ??= abrirBanco();
      return await _abertura!;
    } catch (erro) {
      _abertura = null;
      rethrow;
    }
  }
  Future<Database> abrirBanco() async {
    final pasta = await getDatabasesPath();
    final caminho = join(pasta, 'sessoes.db');
    return openDatabase(
      caminho,
      version: 1,
      onCreate: (banco, versao) async {
        await banco.execute('''
          CREATE TABLE sessoes (
            id INTEGER PRIMARY KEY,
            tema TEXT NOT NULL CHECK(length(trim(tema)) >= 3),
            minutos INTEGER NOT NULL CHECK(minutos BETWEEN 1 AND 240),
            observacao TEXT NOT NULL DEFAULT ''
          )
        ''');
      },
    );
  }
  Future<int> cadastrar(SessaoEstudo sessao) async {
    final banco = await database;
    return banco.insert('sessoes', sessao.toMap());
  }
  Future<List<SessaoEstudo>> listar() async {
    final banco = await database;
    final linhas = await banco.query(
      'sessoes',
      columns: ['id', 'tema', 'minutos', 'observacao'],
      orderBy: 'id DESC',
    );
    return linhas.map((linha) => SessaoEstudo.fromMap(linha)).toList();
  }
  Future<int> atualizar(SessaoEstudo sessao) async {
    final id = sessao.id;
    if (id == null) {
      throw ArgumentError('Atualização exige ID.');
    }
    final banco = await database;
    final valores = sessao.toMap();
    valores.remove('id');
    return banco.update(
      'sessoes',
      valores,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<int> excluir(int id) async {
    final banco = await database;
    return banco.delete(
      'sessoes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}