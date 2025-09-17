import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final supabase = Supabase.instance.client;

// Ambil alamat berdasarkan dusun
static Future<List<Map<String, dynamic>>> getAlamatByDusun(String query) async {
  try {
    final response = await supabase
        .from('alamat')
        .select()
        .ilike('dusun', '%$query%');

    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    print("Error getAlamatByDusun: $e");
    return [];
  }
}

  // 🔹 Insert data siswa
  static Future<bool> insertSiswa(Map<String, dynamic> data) async {
    try {
      await supabase.from('siswa').insert(data);
      return true; // sukses
    } catch (e) {
      print("Error insertSiswa: $e");
      return false; // gagal
    }
  }

  // 🔹 Ambil semua siswa
  static Future<List<Map<String, dynamic>>> getSiswa() async {
    try {
      final response = await supabase.from('siswa').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error getSiswa: $e");
      return [];
    }
  }

  // 🔹 Update siswa berdasarkan ID
  static Future<bool> updateSiswa(int id, Map<String, dynamic> data) async {
    try {
      await supabase.from('siswa').update(data).eq('id', id);
      return true;
    } catch (e) {
      print("Error updateSiswa: $e");
      return false;
    }
  }

  // 🔹 Hapus siswa berdasarkan ID
  static Future<bool> deleteSiswa(int id) async {
    try {
      await supabase.from('siswa').delete().eq('id', id);
      return true;
    } catch (e) {
      print("Error deleteSiswa: $e");
      return false;
    }
  }

  // 🔹 Ambil data alamat (autocomplete)
  static Future<List<String>> getAlamatSuggestions(String query) async {
    try {
      final response = await supabase
          .from('alamat')
          .select()
          .ilike('desa', '%$query%'); // cari desa berdasarkan input user

      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response);

      return data
          .map((e) =>
              "${e['dusun']}, ${e['desa']}, ${e['kecamatan']}, ${e['kabupaten']}, ${e['kode_pos']}")
          .toList();
    } catch (e) {
      print("Error getAlamatSuggestions: $e");
      return [];
    }
  }
}