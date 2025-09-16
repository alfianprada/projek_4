// lib/pages/biodata_form.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_4/pages/result_page.dart';
import 'package:projek_4/supabase_service.dart';

class BiodataFormPage extends StatefulWidget {
  const BiodataFormPage({super.key});
  @override
  State<BiodataFormPage> createState() => _BiodataFormPageState();
}

class _BiodataFormPageState extends State<BiodataFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Data diri
  final nisnController = TextEditingController();
  final namaController = TextEditingController();
  String? selectedGender;
  String? selectedAgama;
  final ttlController = TextEditingController();
  final hpController = TextEditingController();
  final nikController = TextEditingController();

  // Alamat
  final jalanController = TextEditingController();
  final rtRwController = TextEditingController();
  final dusunController = TextEditingController();
  final desaController = TextEditingController();
  final kecamatanController = TextEditingController();
  final kabupatenController = TextEditingController();
  final provinsiController = TextEditingController(text: 'Jawa Timur');
  final kodePosController = TextEditingController();

  // Orang tua/wali
  final ayahController = TextEditingController();
  final ibuController = TextEditingController();
  final waliController = TextEditingController();
  final alamatWaliController = TextEditingController();

  List<String> dusunList = [];
  bool loadingDusun = false;

  @override
  void initState() {
    super.initState();
    _loadDusunSafe();
  }

  Future<bool> _hasInternet() async {
    final c = await Connectivity().checkConnectivity();
    return c != ConnectivityResult.none;
  }

  Future<void> _loadDusunSafe() async {
    setState(() => loadingDusun = true);

    if (!await _hasInternet()) {
      _showSnack('Tidak ada koneksi internet', isError: true);
      setState(() => loadingDusun = false);
      return;
    }

    final list = await SupabaseService.getAllDusun();
    setState(() {
      dusunList = list;
      loadingDusun = false;
    });
  }

  Future<void> _onDusunSelected(String dusun) async {
    // cek koneksi
    if (!await _hasInternet()) {
      _showSnack('Tidak ada koneksi internet', isError: true);
      return;
    }

    final data = await SupabaseService.getAlamatByDusun(dusun);
    if (data == null) {
      _showSnack('Data alamat tidak ditemukan untuk "$dusun"', isError: true);
      return;
    }

    setState(() {
      dusunController.text = data['dusun']?.toString() ?? '';
      desaController.text = data['desa']?.toString() ?? '';
      kecamatanController.text = data['kecamatan']?.toString() ?? '';
      kabupatenController.text = data['kabupaten']?.toString() ?? '';
      kodePosController.text = data['kode_pos']?.toString() ?? '';
    });
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: isError ? Colors.red : Colors.green),
    );
  }

  @override
  void dispose() {
    nisnController.dispose();
    namaController.dispose();
    ttlController.dispose();
    hpController.dispose();
    nikController.dispose();

    jalanController.dispose();
    rtRwController.dispose();
    dusunController.dispose();
    desaController.dispose();
    kecamatanController.dispose();
    kabupatenController.dispose();
    kodePosController.dispose();
    provinsiController.dispose();

    ayahController.dispose();
    ibuController.dispose();
    waliController.dispose();
    alamatWaliController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // main scaffold & form layout (match screenshot styling)
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF5B2DF9), Color(0xFF6F5CE8)]),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Center(
                child: Text('Formulir Biodata',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Data Diri card
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Data Diri', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.blue)),
                        const SizedBox(height: 8),
                        _iconField('NISN', nisnController, Icons.badge),
                        _iconField('Nama Lengkap', namaController, Icons.person),
                        _dropdownField('Jenis Kelamin', ['Laki-laki', 'Perempuan'], selectedGender, (v) => setState(() => selectedGender = v), Icons.wc),
                        _dropdownField('Agama', ['Islam', 'Kristen', 'Katolik', 'Hindu', 'Budha'], selectedAgama, (v) => setState(() => selectedAgama = v), Icons.church),
                        _iconField('Tanggal Lahir', ttlController, Icons.calendar_today),
                        _iconField('No. HP', hpController, Icons.phone),
                        _iconField('NIK', nikController, Icons.credit_card),
                      ]),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Alamat card
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Alamat', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.blue)),
                        const SizedBox(height: 8),
                        _iconField('Jalan', jalanController, Icons.home),
                        _iconField('RT / RW', rtRwController, Icons.format_list_numbered),
                        // Autocomplete
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: loadingDusun
                              ? const LinearProgressIndicator()
                              : Autocomplete<String>(
                                  optionsBuilder: (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
                                    return dusunList.where((d) => d.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                                  },
                                  onSelected: (val) => _onDusunSelected(val),
                                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                                    return TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        labelText: 'Dusun',
                                        prefixIcon: const Icon(Icons.account_tree, color: Color(0xFF7C4DFF)),
                                        filled: true,
                                        fillColor: Colors.grey.shade100,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        _readOnlyIconField('Desa', desaController, Icons.location_city),
                        _readOnlyIconField('Kecamatan', kecamatanController, Icons.map),
                        _readOnlyIconField('Kabupaten', kabupatenController, Icons.apartment),
                        _readOnlyIconField('Provinsi', provinsiController, Icons.flag),
                        _readOnlyIconField('Kode Pos', kodePosController, Icons.markunread_mailbox),
                      ]),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Orang Tua / Wali card
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Orang Tua / Wali', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.blue)),
                        const SizedBox(height: 8),
                        _iconField('Nama Ayah', ayahController, Icons.male),
                        _iconField('Nama Ibu', ibuController, Icons.female),
                        _iconField('Nama Wali', waliController, Icons.people),
                        _iconField('Alamat Wali', alamatWaliController, Icons.location_on),
                      ]),
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF5B2DF9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResultPage(
                                nisn: nisnController.text,
                                nama: namaController.text,
                                jenisKelamin: selectedGender ?? '',
                                agama: selectedAgama ?? '',
                                tglLahir: ttlController.text,
                                hp: hpController.text,
                                nik: nikController.text,
                                jalan: jalanController.text,
                                rtRw: rtRwController.text,
                                dusun: dusunController.text,
                                desa: desaController.text,
                                kecamatan: kecamatanController.text,
                                kabupaten: kabupatenController.text,
                                provinsi: provinsiController.text,
                                kodePos: kodePosController.text,
                                ayah: ayahController.text,
                                ibu: ibuController.text,
                                wali: waliController.text,
                                alamatWali: alamatWaliController.text,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text('Simpan & Lihat Hasil', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconField(String label, TextEditingController c, IconData icon) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: TextFormField(
          controller: c,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: const Color(0xFF7C4DFF)),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      );

  Widget _readOnlyIconField(String label, TextEditingController c, IconData icon) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: TextFormField(
          controller: c,
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: const Color(0xFF7C4DFF)),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      );

  Widget _dropdownField(String label, List<String> items, String? value, Function(String?) onChanged, IconData icon) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: const Color(0xFF7C4DFF)),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      );
}
