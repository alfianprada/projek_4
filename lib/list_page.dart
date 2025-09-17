// lib/list_page.dart
import 'package:flutter/material.dart';
import 'package:projek_4/pages/form_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> siswa = [];
  bool isLoading = true;

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    try {
      final response = await supabase
          .from('siswa')
          .select('*')
          .order('created_at', ascending: false);

      if (response != null && response is List) {
        setState(() {
          siswa = List<Map<String, dynamic>>.from(response);
        });
      } else {
        setState(() {
          siswa = [];
        });
      }
    } catch (e) {
      print("Error fetchData: $e");
      setState(() {
        siswa = [];
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Hapus di Supabase — kembalikan true kalau sukses
  Future<bool> deleteSiswaFromDb(String id) async {
    try {
      final res = await supabase.from('siswa').delete().eq('id', id);
      // biasanya res berupa jumlah row atau list tergantung versi
      return true;
    } catch (e) {
      print("Error deleteSiswaFromDb: $e");
      return false;
    }
  }

  /// Dipakai saat tombol hapus ditekan: hapus lokal dulu (UI), lalu hapus di DB
  Future<void> performDeleteWithLocalRemoval(int index, String id) async {
    // simpan data sementara kalau perlu rollback
    final removed = siswa[index];
    setState(() {
      siswa.removeAt(index); // langsung hapus di UI supaya tidak ada widget dismissed still in tree
    });

    final ok = await deleteSiswaFromDb(id);
    if (ok) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Data berhasil dihapus")));
    } else {
      // kembalikan data (rollback) atau fetch ulang dari DB
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Gagal hapus di server, sinkron ulang...")));
      await fetchData();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Siswa"),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : siswa.isEmpty
              ? const Center(
                  child: Text(
                  "Belum ada data",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: siswa.length,
                  itemBuilder: (context, index) {
                    final item = siswa[index];
                    final id = item['id'].toString();

                    return Dismissible(
                      key: Key(id),
                      background: Container(
                        padding: const EdgeInsets.only(left: 20),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.edit, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        padding: const EdgeInsets.only(right: 20),
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),

                      // confirmDismiss: kita tampilkan dialog konfirmasi
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          // swipe kanan -> edit: buka FormPage, jangan hapus
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FormPage(siswa: item),
                            ),
                          );
                          if (result == true) fetchData();
                          return false; // jangan biarkan Dismissible menghapus widget
                        } else if (direction == DismissDirection.endToStart) {
                          // swipe kiri -> konfirmasi hapus
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Hapus Data"),
                              content: const Text(
                                  "Apakah kamu yakin ingin menghapus data ini?"),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("Batal")),
                                TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text("Hapus")),
                              ],
                            ),
                          );
                          return confirm == true; // kalau true, Dismissible akan proceed to dismiss
                        }
                        return false;
                      },

                      // onDismissed: widget sudah di-removed dari tree oleh Dismissible,
                      // kita panggil hapus DB (atau fetch ulang)
                      onDismissed: (direction) async {
                        // di sini index mungkin sudah tidak valid karena list berubah saat dismiss animation
                        // jadi hapus berdasarkan id, lalu sinkron ulang
                        final ok = await deleteSiswaFromDb(id);
                        if (ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Data berhasil dihapus")));
                          // pastikan sinkron local list dengan DB
                          await fetchData();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Gagal hapus di server")));
                          await fetchData();
                        }
                      },

                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade200,
                              Colors.purple.shade400
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(2, 3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: Text(
                              (item['nama'] != null &&
                                      item['nama'].toString().isNotEmpty)
                                  ? item['nama'][0].toUpperCase()
                                  : "?",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple),
                            ),
                          ),
                          title: Text(
                            item['nama']?.toString() ?? 'NO NAMA',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.credit_card,
                                      size: 16, color: Colors.white70),
                                  const SizedBox(width: 4),
                                  Text("NISN: ${item['nisn'] ?? '-'}",
                                      style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.male,
                                      size: 16, color: Colors.white70),
                                  const SizedBox(width: 4),
                                  Text("JK: ${item['jenis_kelamin'] ?? '-'}",
                                      style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.phone,
                                      size: 16, color: Colors.white70),
                                  const SizedBox(width: 4),
                                  Text("HP: ${item['hp'] ?? '-'}",
                                      style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.home,
                                      size: 16, color: Colors.white70),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                        "Alamat: ${item['jalan'] ?? ''}, ${item['dusun'] ?? ''}, "
                                        "${item['desa'] ?? ''}, ${item['kecamatan'] ?? ''}, "
                                        "${item['kabupaten'] ?? ''}, ${item['provinsi'] ?? ''}, "
                                        "${item['kode_pos'] ?? ''}",
                                        style: const TextStyle(color: Colors.white70)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                          // tombol edit & delete kecil di dalam card (alternatif)
                          trailing: Wrap(
                            spacing: 4,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.white),
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FormPage(siswa: item),
                                    ),
                                  );
                                  if (result == true) {
                                    await fetchData();
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.white),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Hapus Data"),
                                      content: const Text(
                                          "Apakah kamu yakin ingin menghapus data ini?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text("Batal")),
                                        TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text("Hapus")),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    // pastikan dialog tertutup dulu lalu hapus lokal & DB
                                    await performDeleteWithLocalRemoval(index, id);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormPage()),
          );

          if (result == true) {
            fetchData(); // refresh setelah tambah data
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
