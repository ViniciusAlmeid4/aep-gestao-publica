import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/address.dart';
import '../models/post_request_model.dart';
import '../viewmodels/requests_viewmodel.dart';

class CreateRequestDialog extends StatefulWidget {
  const CreateRequestDialog({super.key});

  @override
  State<CreateRequestDialog> createState() => _CreateRequestDialogState();
}

class _CreateRequestDialogState extends State<CreateRequestDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _linkedFileController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  String _category = 'INFRASTRUCTURE';
  bool _isAnonymous = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _linkedFileController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final viewModel = context.read<RequestsViewModel>();
    final model = PostRequestModel(
      category: _category,
      description: _descriptionController.text.trim(),
      linkedFile: _linkedFileController.text.trim(),
      isAnonymous: _isAnonymous,
      address: Address(
        street: _streetController.text.trim(),
        number: _numberController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
      ),
    );

    final success = await viewModel.createRequest(model);
    if (success && mounted) {
      Navigator.of(context).pop(true);
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(viewModel.error ?? 'Erro ao criar solicitação.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestsViewModel>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1124),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 28, 18, 22),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Form(
            key: _formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 880;
                final fieldWidth = compact
                    ? constraints.maxWidth
                    : (constraints.maxWidth - 72) / 3;
                final descriptionWidth = compact
                    ? constraints.maxWidth
                    : constraints.maxWidth * 0.79;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: 36,
                      runSpacing: 18,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        SizedBox(
                          width: fieldWidth,
                          child: DropdownButtonFormField<String>(
                            initialValue: _category,
                            dropdownColor: const Color(0xFF111111),
                            style: const TextStyle(color: Colors.white),
                            decoration: _fieldDecoration('Categoria'),
                            items: const [
                              DropdownMenuItem(
                                value: 'INFRASTRUCTURE',
                                child: Text('INFRAESTRUTURA'),
                              ),
                              DropdownMenuItem(
                                value: 'SANITATION',
                                child: Text('SANEAMENTO'),
                              ),
                              DropdownMenuItem(
                                value: 'PUBLIC_LIGHTING',
                                child: Text('ILUMINAÇÃO PÚBLICA'),
                              ),
                              DropdownMenuItem(
                                value: 'URBAN_CLEANING',
                                child: Text('LIMPEZA URBANA'),
                              ),
                              DropdownMenuItem(
                                value: 'HEALTHCARE',
                                child: Text('SAÚDE'),
                              ),
                              DropdownMenuItem(
                                value: 'EDUCATION',
                                child: Text('EDUCAÇÃO'),
                              ),
                              DropdownMenuItem(
                                value: 'PUBLIC_SAFETY',
                                child: Text('SEGURANÇA PÚBLICA'),
                              ),
                              DropdownMenuItem(
                                value: 'ENVIRONMENT',
                                child: Text('MEIO AMBIENTE'),
                              ),
                              DropdownMenuItem(
                                value: 'ANIMAL_WELFARE',
                                child: Text('BEM-ESTAR ANIMAL'),
                              ),
                              DropdownMenuItem(
                                value: 'OTHERS',
                                child: Text('OUTROS'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _category = value);
                              }
                            },
                          ),
                        ),
                        _Field(
                          width: fieldWidth,
                          label: 'Anexo',
                          hintText: 'Nome do arquivo...',
                          controller: _linkedFileController,
                        ),
                        SizedBox(
                          width: compact ? constraints.maxWidth : 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Anônima',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 38,
                                height: 38,
                                child: Checkbox(
                                  value: _isAnonymous,
                                  onChanged: (value) {
                                    setState(
                                      () => _isAnonymous = value ?? false,
                                    );
                                  },
                                  checkColor: const Color(0xFF111111),
                                  activeColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _Field(
                          width: fieldWidth,
                          label: 'CEP',
                          controller: _zipCodeController,
                          validator: _required('Informe o CEP'),
                        ),
                        _Field(
                          width: fieldWidth,
                          label: 'Número',
                          controller: _numberController,
                          validator: _required('Informe o número'),
                        ),
                        _Field(
                          width: fieldWidth,
                          label: 'Logradouro',
                          controller: _streetController,
                          validator: _required('Informe o logradouro'),
                        ),
                        _Field(
                          width: fieldWidth,
                          label: 'Cidade',
                          controller: _cityController,
                          validator: _required('Informe a cidade'),
                        ),
                        _Field(
                          width: fieldWidth,
                          label: 'Estado',
                          controller: _stateController,
                          validator: _required('Informe o estado'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 42,
                      runSpacing: 18,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        _Field(
                          width: descriptionWidth,
                          label: 'Descrição',
                          controller: _descriptionController,
                          maxLines: 6,
                          validator: _required('Informe a descrição'),
                        ),
                        SizedBox(
                          width: 156,
                          height: 38,
                          child: OutlinedButton(
                            onPressed: viewModel.isSubmitting ? null : _submit,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              disabledForegroundColor: Colors.white70,
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.zero,
                              textStyle: const TextStyle(fontSize: 14),
                            ),
                            child: viewModel.isSubmitting
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Cadastrar solicitação'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String? Function(String?) _required(String message) {
    return (value) => value == null || value.trim().isEmpty ? message : null;
  }
}

class _Field extends StatelessWidget {
  final double width;
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final int maxLines;
  final String? Function(String?)? validator;

  const _Field({
    required this.width,
    required this.label,
    required this.controller,
    this.hintText,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        decoration: _fieldDecoration(label, hintText: hintText),
        validator: validator,
      ),
    );
  }
}

InputDecoration _fieldDecoration(String label, {String? hintText}) {
  const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(color: Colors.white),
  );

  return InputDecoration(
    labelText: label,
    hintText: hintText,
    labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
    hintStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    enabledBorder: border,
    focusedBorder: border,
    errorBorder: border.copyWith(
      borderSide: const BorderSide(color: Color(0xFFFF8A80)),
    ),
    focusedErrorBorder: border.copyWith(
      borderSide: const BorderSide(color: Color(0xFFFF8A80)),
    ),
    errorStyle: const TextStyle(color: Color(0xFFFF8A80), fontSize: 11),
    filled: true,
    fillColor: const Color(0xFF111111),
  );
}
