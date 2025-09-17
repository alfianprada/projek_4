import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projek_4/supabase_service.dart';

// Inisialisasi Supabase
final supabase = Supabase.instance.client;

class FormPage extends StatefulWidget {
  const FormPage({Key? key, this.siswa});

  final Map<String, dynamic>? siswa; // jika ada, berarti edit

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller input
  final TextEditingController nisnCtrl = TextEditingController();
  final TextEditingController namaCtrl = TextEditingController();
  final TextEditingController ayahCtrl = TextEditingController();
  final TextEditingController ibuCtrl = TextEditingController();
  final TextEditingController waliCtrl = TextEditingController();
  final TextEditingController tlpCtrl = TextEditingController();
  final TextEditingController nikCtrl = TextEditingController();
  final TextEditingController jalanCtrl = TextEditingController();
  final TextEditingController dusunCtrl = TextEditingController();
  final TextEditingController kecCtrl = TextEditingController();
  final TextEditingController kabCtrl = TextEditingController();
  final TextEditingController provCtrl = TextEditingController();
  final TextEditingController kodePosCtrl = TextEditingController();
  final TextEditingController tempatLahirCtrl = TextEditingController();
  DateTime? tanggalLahir;

  String? gender;
  String? agama;

  // Untuk autocomplete dusun
  List<String> dusunList = [];
  bool isLoadingDusun = false;

  @override
  void initState() {
    super.initState();
    _getDusunData();
    _populateForm(); // isi data jika edit
  }

  void _populateForm() {
    if (widget.siswa != null) {
      final s = widget.siswa!;
      nisnCtrl.text = s['nisn'] ?? '';
      namaCtrl.text = s['nama'] ?? '';
      ayahCtrl.text = s['ayah'] ?? '';
      ibuCtrl.text = s['ibu'] ?? '';
      waliCtrl.text = s['wali'] ?? '';
      tlpCtrl.text = s['hp'] ?? '';
      nikCtrl.text = s['nik'] ?? '';
      jalanCtrl.text = s['jalan'] ?? '';
      dusunCtrl.text = s['dusun'] ?? '';
      kecCtrl.text = s['kecamatan'] ?? '';
      kabCtrl.text = s['kabupaten'] ?? '';
      provCtrl.text = s['provinsi'] ?? '';
      kodePosCtrl.text = s['kode_pos'] ?? '';
      tempatLahirCtrl.text = s['tempat_lahir'] ?? '';
      gender = s['jenis_kelamin'];
      agama = s['agama'];
      if (s['tgl_lahir'] != null) {
        tanggalLahir = DateTime.tryParse(s['tgl_lahir']);
      }
    }
  }

  Future<void> _getDusunData() async {
    setState(() => isLoadingDusun = true);
    final response = await supabase.from('alamat').select('dusun');
    if (response != null) {
      setState(() {
        dusunList = List<String>.from(response.map((e) => e['dusun']));
        isLoadingDusun = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5D2DFD), Color(0xFF7B4CFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.siswa != null ? "Edit Biodata" : "Formulir Biodata",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // FORM
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildSectionTitle("Data Diri"),
                      _buildInput(Icons.credit_card, "NISN", nisnCtrl,
                          validator: (val) {
                        if (val!.isEmpty || val.length != 10) {
                          return "NISN harus 10 karakter";
                        }
                        return null;
                      }),
                      _buildInput(Icons.person, "Nama Lengkap", namaCtrl,
                          validator: (val) {
                        if (val!.isEmpty) return "Nama wajib diisi";
                        return null;
                      }),
                      _buildDropdown(Icons.male, "Jenis Kelamin",
                          ["Laki-laki", "Perempuan"], (val) {
                        setState(() => gender = val);
                      }, gender),
                      _buildDropdown(Icons.mosque, "Agama",
                          ["Islam", "Kristen", "Hindu", "Budha", "Lainnya"],
                          (val) {
                        setState(() => agama = val);
                      }, agama),
                      _buildInput(Icons.place, "Tempat Lahir", tempatLahirCtrl,
                          validator: (val) =>
                              val!.isEmpty ? "Tempat lahir wajib diisi" : null),
                      _buildDatePicker(),
                      _buildInput(Icons.phone, "No. HP", tlpCtrl,
                          validator: (val) {
                        if (val!.isEmpty) return "Nomor HP wajib diisi";
                        if (val.length < 12 || val.length > 15) {
                          return "Nomor HP minimal 12 dan maksimal 15 angka";
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                          return "Nomor HP harus angka";
                        }
                        return null;
                      }),
                      _buildInput(Icons.badge, "NIK", nikCtrl,
                          validator: (val) =>
                              val!.isEmpty ? "NIK wajib diisi" : null),

                      const SizedBox(height: 15),
                      _buildSectionTitle("Alamat"),
                      _buildInput(Icons.home, "Jalan", jalanCtrl,
                          validator: (val) =>
                              val!.isEmpty ? "Jalan wajib diisi" : null),
                      // Autocomplete dusun
                      Autocomplete<Map<String, dynamic>>(
                        optionsBuilder: (TextEditingValue textEditingValue) async {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<Map<String, dynamic>>.empty();
                          }
                          return await SupabaseService.getAlamatByDusun(
                              textEditingValue.text);
                        },
                        displayStringForOption: (option) => option['dusun'] ?? "",
                        onSelected: (val) {
                          dusunCtrl.text = val['dusun'] ?? "";
                          kecCtrl.text = val['kecamatan'] ?? "";
                          kabCtrl.text = val['kabupaten'] ?? "";
                          provCtrl.text = val['provinsi'] ?? "";
                          kodePosCtrl.text = val['kode_pos'].toString();
                        },
                        fieldViewBuilder: (context, controller, focusNode,
                                onEditingComplete) =>
                            _buildInput(Icons.location_city, "Dusun", controller,
                                focusNode: focusNode,
                                onEditingComplete: onEditingComplete),
                      ),
                      _buildInput(Icons.apartment, "Kecamatan", kecCtrl),
                      _buildInput(Icons.maps_home_work, "Kabupaten", kabCtrl),
                      _buildInput(Icons.flag, "Provinsi", provCtrl),
                      _buildInput(Icons.numbers, "Kode Pos", kodePosCtrl),

                      const SizedBox(height: 15),
                      _buildSectionTitle("Orang Tua / Wali"),
                      _buildInput(Icons.male, "Nama Ayah", ayahCtrl,
                          validator: (val) =>
                              val!.isEmpty ? "Nama Ayah wajib diisi" : null),
                      _buildInput(Icons.female, "Nama Ibu", ibuCtrl,
                          validator: (val) =>
                              val!.isEmpty ? "Nama Ibu wajib diisi" : null),
                      _buildInput(Icons.group, "Nama Wali", waliCtrl),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

                          final data = {
                            'nisn': nisnCtrl.text,
                            'nama': namaCtrl.text,
                            'ayah': ayahCtrl.text,
                            'ibu': ibuCtrl.text,
                            'wali': waliCtrl.text,
                            'jenis_kelamin': gender,
                            'agama': agama,
                            'tempat_lahir': tempatLahirCtrl.text,
                            'tgl_lahir': tanggalLahir?.toIso8601String(),
                            'hp': tlpCtrl.text,
                            'nik': nikCtrl.text,
                            'jalan': jalanCtrl.text,
                            'dusun': dusunCtrl.text,
                            'kecamatan': kecCtrl.text,
                            'kabupaten': kabCtrl.text,
                            'provinsi': provCtrl.text,
                            'kode_pos': kodePosCtrl.text,
                          };

                          try {
                            if (widget.siswa != null) {
                              // update
                              await supabase
                                  .from('siswa')
                                  .update(data)
                                  .eq('id', widget.siswa!['id']);
                            } else {
                              // insert baru
                              await supabase.from('siswa').insert(data);
                            }

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(widget.siswa != null
                                      ? "Data berhasil diupdate"
                                      : "Data berhasil disimpan")));
                              Navigator.pop(context, true);
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: $e")));
                            }
                          }
                        },
                        child: Text(widget.siswa != null ? "Update" : "Simpan"),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== WIDGET REUSABLE =====
  Widget _buildInput(IconData icon, String hint,
      TextEditingController controller,
      {String? Function(String?)? validator,
      FocusNode? focusNode,
      void Function()? onEditingComplete}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          hintText: hint,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown(IconData icon, String hint, List<String> items,
      void Function(String?) onChanged, String? value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          border: InputBorder.none,
        ),
        hint: Text(hint),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? "$hint wajib dipilih" : null,
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: TextEditingController(
            text: tanggalLahir == null
                ? ""
                : "${tanggalLahir!.day}-${tanggalLahir!.month}-${tanggalLahir!.year}"),
        readOnly: true,
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: tanggalLahir ?? DateTime(2005),
            firstDate: DateTime(1990),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            setState(() {
              tanggalLahir = picked;
            });
          }
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_month, color: Colors.deepPurple),
          hintText: "Tanggal Lahir",
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (val) =>
            tanggalLahir == null ? "Tanggal lahir wajib diisi" : null,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
      ),
    );
  }
}
