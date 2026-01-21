import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

class AuthService {
  final supabase = SupabaseConfig.client;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  bool isLoggedIn() {
    return supabase.auth.currentUser != null;
  }

  Session? getSession() {
    return supabase.auth.currentSession;
  }

  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;

  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      final user = getCurrentUser();
      if (user == null) return null;
      
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();
      
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
