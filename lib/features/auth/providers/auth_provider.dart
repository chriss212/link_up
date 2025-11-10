import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:link_up/features/auth/repositories/auth_repository.dart'; // 👈 Ajusta la ruta

part 'auth_provider.g.dart';

// Define los estados de autenticación
enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

// El estado que la UI escuchará
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthState({this.status = AuthStatus.initial, this.user, this.errorMessage});

  // Método helper para copiar el estado
  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool clearError = false, // Helper para limpiar errores
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

// El Notifier
@riverpod
class Auth extends _$Auth {
  late AuthRepository _authRepository;

  @override
  AuthState build() {
    // Lee el repositorio
    _authRepository = ref.watch(authRepositoryProvider);
    // Estado inicial
    return AuthState(status: AuthStatus.unauthenticated);
  }

  // Método de Login
  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    try {
      final authResponse = await _authRepository.login(email, password);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: authResponse.user,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated, // Permanece sin autenticar
        errorMessage: e.toString(),
      );
    }
  }

  // Método de Registro
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    try {
      await _authRepository.register(
        fullName: fullName,
        email: email,
        password: password,
      );

      // Vuelve al estado normal (no autenticado) para que pueda hacer login
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  // Método de Logout
  Future<void> logout() async {
    await _authRepository.deleteToken();
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
  }

  // Método para limpiar errores (si el usuario cierra el SnackBar)
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
