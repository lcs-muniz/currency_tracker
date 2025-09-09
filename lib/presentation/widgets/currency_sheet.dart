import 'package:currency_tracker/domain/entities/currency.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CurrencySheet extends StatefulWidget {
  final Currency? currency;
  final Future<void> Function(Currency) onSubmit;
  final FlutterComputed<bool> isExecuting;

  const CurrencySheet({
    super.key,
    this.currency,
    required this.onSubmit,
    required this.isExecuting,
  });

  static Future<void> show({
    required BuildContext context,
    Currency? currency,
    required Future<void> Function(Currency) onSubmit,
    required FlutterComputed<bool> isExecuting,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CurrencySheet(
        currency: currency,
        onSubmit: onSubmit,
        isExecuting: isExecuting,
      ),
    );
  }

  @override
  State<CurrencySheet> createState() => _CurrencySheetState();
}

class _CurrencySheetState extends State<CurrencySheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _quoteController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.currency?.code ?? '');
    _nameController = TextEditingController(text: widget.currency?.name ?? '');
    _quoteController = TextEditingController(
      text: widget.currency?.latestQuote.toString() ?? '',
    );
    _isFavorite = widget.currency?.isFavorite ?? false;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newCurrency = Currency(
        code: _codeController.text.toUpperCase(),
        name: _nameController.text,
        isFavorite: _isFavorite,
        latestQuote: double.tryParse(_quoteController.text) ?? 0.0,
      );
      await widget.onSubmit(newCurrency); // aguarda a execução

      Navigator.pop(context); // fecha o modal após o submit
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.currency != null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Cabeçalho
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.currency_exchange,
                    color: theme.colorScheme.onPrimary),
                const SizedBox(width: 8),
                Text(
                  isEdit ? 'Editar Moeda' : 'Adicionar Moeda',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Formulário
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _codeController,
                      decoration:
                          const InputDecoration(labelText: 'Código da Moeda'),
                      textCapitalization: TextCapitalization.characters,
                      enabled: !isEdit,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o código da moeda';
                        }
                        if (value.length < 2 || value.length > 5) {
                          return 'Código inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(labelText: 'Nome da Moeda'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o nome da moeda';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _quoteController,
                      decoration: const InputDecoration(
                          labelText: 'Cotação Inicial (opcional)'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('Favorita'),
                      value: _isFavorite,
                      onChanged: (val) {
                        setState(() {
                          _isFavorite = val;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Watch((context) {
                      var isExecuting = widget.isExecuting.value;
                      print(
                          'isExecuting: $isExecuting horario ${DateTime.now()}');
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isExecuting ? null : _submit,
                          child: isExecuting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(isEdit
                                  ? 'Salvar Alterações'
                                  : 'Adicionar Moeda'),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
