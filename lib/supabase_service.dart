// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  /// Ambil daftar unique dusun dari tabel 'alamat'
  static Future<List<String>> getAllDusun() async {
    try {
      final response = await client
          .from('alamat')
          .select('dusun')
          .order('dusun', ascending: true);
      final list = (response as List)
          .map((e) => (e['dusun'] ?? '').toString())
          .where((s) => s.isNotEmpty)
          .toSet()
          .toList();
      return list;
    } catch (e) {
      // log error, kembalikan list kosong supaya UI tidak crash
      print('Supabase getAllDusun error: $e');
      return [];
    }
  }

  /// Ambil satu record alamat berdasarkan nama dusun
  static Future<Map<String, dynamic>?> getAlamatByDusun(String dusun) async {
    try {
      final response = await client
          .from('alamat')
          .select('dusun, desa, kecamatan, kabupaten, kode_pos')
          .eq('dusun', dusun)
          .maybeSingle();
      if (response == null) return null;
      return Map<String, dynamic>.from(response);
    } catch (e) {
      print('Supabase getAlamatByDusun error: $e');
      return null;
    }
  }
}
