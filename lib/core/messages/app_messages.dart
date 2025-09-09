class AppMessages {
  static const error = _Error();
}

class _Error {
  const _Error();
  final String defaultError = 'Ocorreu um erro inesperado.';
  final String serverError = 'Falha ao conectar com o servidor.';
  final String cacheError = 'Falha ao carregar dados locais.';
  final String apiError = 'Falha na comunicação com a API.';
  final String apiSaveError = 'Falha ao salvar dados na API.';
  final String apiException = 'Exceção na API.';
  final String databaseError = 'Falha ao operar o banco de dados.';
  final String databaseInsertError = 'Falha ao inserir dados no banco de dados.';
  final String databaseQueryError = 'Falha ao consultar dados no banco de dados.';
  final String databaseUpdateError = 'Falha ao atualizar dados no banco de dados.';
  final String databaseDeleteError = 'Falha ao deletar dados no banco de dados.';
  final String invalidInput = 'Entrada inválida. Verifique os dados fornecidos.';

}