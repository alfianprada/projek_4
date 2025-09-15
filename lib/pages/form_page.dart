import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_4/widgets/custom_textfield.dart';
import 'result_page.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller
  final nisnController = TextEditingController();
  final namaController = TextEditingController();
  final nikController = TextEditingController();
  final telpController = TextEditingController();
  final ttlController = TextEditingController();

  final jalanController = TextEditingController();
  final rtRwController = TextEditingController();
  final dusunController = TextEditingController();
  final kecamatanController = TextEditingController();
  final kabupatenController = TextEditingController();
  final provinsiController = TextEditingController();
  final kodePosController = TextEditingController();

  final ayahController = TextEditingController();
  final ibuController = TextEditingController();
  final waliController = TextEditingController();
  final alamatWaliController = TextEditingController();

  String? selectedGender;
  String? selectedAgama;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      initialDate: DateTime(2005),
    );

    if (picked != null) {
      setState(() {
        ttlController.text =
            "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo)),
          const SizedBox(height: 8),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header dengan gradient
          Container(
            height: 150,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Center(
              child: Text("Formulir Biodata",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
            ),
          ),

          // Body Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildSection("Data Diri", [
                      CustomTextField(
                          label: "NISN",
                          controller: nisnController,
                          type: TextInputType.number,
                          icon: Icons.badge),
                      CustomTextField(
                          label: "Nama Lengkap",
                          controller: namaController,
                          type: TextInputType.text,
                          icon: Icons.person),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Jenis Kelamin",
                          prefixIcon: const Icon(Icons.wc,
                              color: Color.fromARGB(255, 132, 53, 229)), // merah
                        ),
                        value: selectedGender,
                        items: ["Laki-laki", "Perempuan"]
                            .map((g) => DropdownMenuItem(
                                  value: g,
                                  child: Text(g),
                                ))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => selectedGender = val),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Agama",
                          prefixIcon: const Icon(Icons.church,
                              color: Color.fromARGB(255, 132, 53, 229)), // merah
                        ),
                        value: selectedAgama,
                        items: [
                          "Islam",
                          "Kristen",
                          "Katolik",
                          "Hindu",
                          "Budha",
                          "Konghucu"
                        ]
                            .map((a) => DropdownMenuItem(
                                  value: a,
                                  child: Text(a),
                                ))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => selectedAgama = val),
                      ),
                      GestureDetector(
                        onTap: _pickDate,
                        child: AbsorbPointer(
                          child: CustomTextField(
                              label: "Tanggal Lahir",
                              controller: ttlController,
                              type: TextInputType.text,
                              icon: Icons.calendar_today),
                        ),
                      ),
                      CustomTextField(
                          label: "No. HP",
                          controller: telpController,
                          type: TextInputType.phone,
                          icon: Icons.phone),
                      CustomTextField(
                          label: "NIK",
                          controller: nikController,
                          type: TextInputType.number,
                          icon: Icons.credit_card),
                    ]),

                    _buildSection("Alamat", [
                      CustomTextField(
                          label: "Jalan",
                          controller: jalanController,
                          type: TextInputType.text,
                          icon: Icons.home),
                      CustomTextField(
                          label: "RT / RW",
                          controller: rtRwController,
                          type: TextInputType.text,
                          icon: Icons.map),
                      CustomTextField(
                          label: "Dusun",
                          controller: dusunController,
                          type: TextInputType.text,
                          icon: Icons.location_city),
                      CustomTextField(
                          label: "Kecamatan",
                          controller: kecamatanController,
                          type: TextInputType.text,
                          icon: Icons.apartment),
                      CustomTextField(
                          label: "Kabupaten",
                          controller: kabupatenController,
                          type: TextInputType.text,
                          icon: Icons.business),
                      CustomTextField(
                          label: "Provinsi",
                          controller: provinsiController,
                          type: TextInputType.text,
                          icon: Icons.flag),
                      CustomTextField(
                          label: "Kode Pos",
                          controller: kodePosController,
                          type: TextInputType.number,
                          icon: Icons.markunread_mailbox),
                    ]),

                    _buildSection("Orang Tua / Wali", [
                      CustomTextField(
                          label: "Nama Ayah",
                          controller: ayahController,
                          type: TextInputType.text,
                          icon: Icons.male),
                      CustomTextField(
                          label: "Nama Ibu",
                          controller: ibuController,
                          type: TextInputType.text,
                          icon: Icons.female),
                      CustomTextField(
                          label: "Nama Wali",
                          controller: waliController,
                          type: TextInputType.text,
                          icon: Icons.person_outline),
                      CustomTextField(
                          label: "Alamat Wali",
                          controller: alamatWaliController,
                          type: TextInputType.text,
                          icon: Icons.location_on),
                    ]),

                    const SizedBox(height: 24),

                    // Tombol Simpan
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 4,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultPage(
                                nisn: nisnController.text,
                                nama: namaController.text,
                                nik: nikController.text,
                                telp: telpController.text,
                                ttl: ttlController.text,
                                gender: selectedGender ?? "",
                                agama: selectedAgama ?? "",
                                jalan: jalanController.text,
                                rtRw: rtRwController.text,
                                dusun: dusunController.text,
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
                      child: Text("Simpan & Lihat Hasil",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600,color: Color.fromARGB(255, 0, 0, 0)
                              )
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
