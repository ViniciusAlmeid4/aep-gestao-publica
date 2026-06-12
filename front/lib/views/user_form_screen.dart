import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/address.dart';
import '../models/post_user_request.dart';
import '../models/user_model.dart';
import '../viewmodels/users_viewmodel.dart';

class UserFormScreen extends StatefulWidget {
  final String? userId;
  final UserModel? initialUser;

  const UserFormScreen({super.key, this.userId, this.initialUser});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _numberController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'CIDADAO';
  UserModel? _user;
  bool _loadedInitialUser = false;

  bool get _isEditing => widget.userId != null;

  @override
  void initState() {
    super.initState();
    _user = widget.initialUser;
    if (_user != null) {
      _fillForm(_user!);
      _loadedInitialUser = true;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_isEditing && !_loadedInitialUser) {
        final user = await context.read<UsersViewModel>().getUser(
          widget.userId!,
        );
        if (user != null && mounted) {
          setState(() {
            _user = user;
            _fillForm(user);
            _loadedInitialUser = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _zipCodeController.dispose();
    _numberController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillForm(UserModel user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _birthDateController.text = _formatInputDate(user.birthDate);
    _zipCodeController.text = user.address?.zipCode ?? '';
    _numberController.text = user.address?.number ?? '';
    _streetController.text = user.address?.street ?? '';
    _cityController.text = user.address?.city ?? '';
    _stateController.text = user.address?.state ?? '';
    _role = _normalizeRole(user.role);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final birthDate = _parseInputDate(_birthDateController.text.trim());
    final request = PostUserRequest(
      id: _user?.id,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      birthDate: birthDate,
      password: _passwordController.text,
      role: _role,
      address: Address(
        street: _streetController.text.trim(),
        number: _numberController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
      ),
    );

    final viewModel = context.read<UsersViewModel>();
    final success = _isEditing
        ? await viewModel.updateUser(widget.userId!, request)
        : await viewModel.createUser(request);

    if (success && mounted) {
      context.go('/users');
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(viewModel.error ?? 'Erro ao salvar usuário.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UsersViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(onBackPressed: () => context.go('/users')),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(52, 12, 52, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Dados do Usuário',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Form(
                        key: _formKey,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final compact = constraints.maxWidth < 760;
                            return Wrap(
                              spacing: 28,
                              runSpacing: 16,
                              children: [
                                _Field(
                                  width: compact ? constraints.maxWidth : 280,
                                  label: 'Nome',
                                  controller: _nameController,
                                  validator: _required('Informe o nome'),
                                ),
                                _Field(
                                  width: compact ? constraints.maxWidth : 280,
                                  label: 'Email',
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Informe o email';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Email inválido';
                                    }
                                    return null;
                                  },
                                ),
                                _Field(
                                  width: compact ? constraints.maxWidth : 280,
                                  label: 'Data de Nascimento',
                                  controller: _birthDateController,
                                  hintText: 'AAAA-MM-DD',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Informe a data';
                                    }
                                    if (_parseInputDate(value) == null) {
                                      return 'Use AAAA-MM-DD';
                                    }
                                    return null;
                                  },
                                ),
                                _Field(
                                  width: compact ? constraints.maxWidth : 280,
                                  label: 'CEP',
                                  controller: _zipCodeController,
                                  validator: _required('Informe o CEP'),
                                ),
                                _Field(
                                  width: compact ? constraints.maxWidth : 280,
                                  label: 'Número',
                                  controller: _numberController,
                                  validator: _required('Informe o número'),
                                ),
                                _Field(
                                  width: compact ? constraints.maxWidth : 280,
                                  label: 'Logradouro',
                                  controller: _streetController,
                                  validator: _required('Informe o logradouro'),
                                ),
                                _Field(
                                  width: compact ? constraints.maxWidth : 280,
                                  label: 'Cidade',
                                  controller: _cityController,
                                  validator: _required('Informe a cidade'),
                                ),
                                _Field(
                                  width: compact ? constraints.maxWidth : 280,
                                  label: 'Estado',
                                  controller: _stateController,
                                  validator: _required('Informe o estado'),
                                ),
                                SizedBox(
                                  width: compact ? constraints.maxWidth : 280,
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _role,
                                    dropdownColor: const Color(0xFF111111),
                                    style: const TextStyle(color: Colors.white),
                                    decoration: _fieldDecoration('Perfil'),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'CIDADAO',
                                        child: Text('Cidadão'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'FUNCIONARIO_PREFEITURA',
                                        child: Text('Funcionário'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() => _role = value);
                                      }
                                    },
                                  ),
                                ),
                                _Field(
                                  width: compact ? constraints.maxWidth : 280,
                                  label: _isEditing ? 'Nova Senha' : 'Senha',
                                  controller: _passwordController,
                                  obscureText: true,
                                  validator: (value) {
                                    final password = value ?? '';
                                    if (!_isEditing && password.isEmpty) {
                                      return 'Informe a senha';
                                    }
                                    if (password.isNotEmpty &&
                                        password.length < 6) {
                                      return 'Mínimo de 6 caracteres';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 130),
                    Row(
                      children: [
                        SizedBox(
                          width: 132,
                          height: 31,
                          child: OutlinedButton(
                            onPressed: null,
                            style: OutlinedButton.styleFrom(
                              disabledForegroundColor: Colors.white38,
                              side: const BorderSide(color: Colors.white38),
                            ),
                            child: const Text('Desativar'),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 150,
                          height: 31,
                          child: OutlinedButton(
                            onPressed: viewModel.isSubmitting ? null : _submit,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              disabledForegroundColor: Colors.white70,
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
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
                                : const Text('Salvar alterações'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _normalizeRole(String role) {
    if (role == 'FUNCIONARIO_PREFEITURA') return role;
    return 'CIDADAO';
  }

  String _formatInputDate(DateTime? date) {
    if (date == null) return '';
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  DateTime? _parseInputDate(String value) {
    return DateTime.tryParse(value);
  }

  String? Function(String?) _required(String message) {
    return (value) => value == null || value.isEmpty ? message : null;
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBackPressed;

  const _Header({required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 34),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white70)),
      ),
      child: Row(
        children: [
          const Text(
            'Portal público',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Spacer(),
          SizedBox(
            width: 130,
            height: 31,
            child: OutlinedButton(
              onPressed: onBackPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Voltar'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final double width;
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const _Field({
    required this.width,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
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
    borderRadius: BorderRadius.all(Radius.circular(3)),
    borderSide: BorderSide(color: Colors.white),
  );

  return InputDecoration(
    labelText: label,
    hintText: hintText,
    labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
    hintStyle: const TextStyle(color: Colors.white38),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
