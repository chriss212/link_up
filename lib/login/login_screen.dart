import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Importa Riverpod
import 'package:go_router/go_router.dart';
import 'package:link_up/features/auth/providers/auth_provider.dart'; // 2. Importa tu provider
import 'package:link_up/shared/widgets/primary_button.dart'; // (Asegúrate que esta ruta sea correcta)

// 3. Cambia a ConsumerStatefulWidget
class LoginScreen extends ConsumerStatefulWidget {
  static const name = 'login';
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  // 4. Añade FormKey y Controllers
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 6. Método para manejar el login
  void _handleLogin() {
    // Valida el formulario
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;

      // Llama al notifier de Riverpod
      ref.read(authProvider.notifier).login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 7. Escucha los cambios de estado para navegación o errores
    ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        // Éxito: Navega al feed
        context.go('/feed');
      }
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        // Error: Muestra un SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        // Limpia el error para no mostrarlo de nuevo
        ref.read(authProvider.notifier).clearError();
      }
    });

    // 8. Obtiene el estado actual (para mostrar 'cargando')
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/welcome'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(16),
            // 5. Asigna el FormKey
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ... (Tu columna de Títulos 'Welcome back!') ...
                  TextFormField(
                    controller: _emailController, // Asigna controller
                    decoration: const InputDecoration(
                      labelText: 'Email', // Tu DTO de login pide 'email'
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController, // Asigna controller
                    obscureText: _obscureText, // Usa la variable de estado
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => _obscureText = !_obscureText),
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  // ... (Tu UI de Forgot Password) ...
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    // ❗️❗️ SOLUCIÓN 4: Tu 'PrimaryButton' no acepta 'child', solo 'label'.
                    // Mostraremos un texto diferente en el label si está cargando.
                    child: PrimaryButton(
                      label: isLoading ? 'Loading...' : 'Log In',
                      onPressed: isLoading ? null : _handleLogin,
                    ),
                  ),
                  // ... (Resto de tu UI) ...
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
