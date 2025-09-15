import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String nisn, nama, nik, telp, ttl, gender, agama;
  final String jalan, rtRw, dusun, kecamatan, kabupaten, provinsi, kodePos;
  final String ayah, ibu, wali, alamatWali;

  const ResultPage({
    super.key,
    required this.nisn,
    required this.nama,
    required this.nik,
    required this.telp,
    required this.ttl,
    required this.gender,
    required this.agama,
    required this.jalan,
    required this.rtRw,
    required this.dusun,
    required this.kecamatan,
    required this.kabupaten,
    required this.provinsi,
    required this.kodePos,
    required this.ayah,
    required this.ibu,
    required this.wali,
    required this.alamatWali,
  });

  Widget _buildInfoCard(IconData icon, String title, List<String> details) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.indigo.shade100,
              child: Icon(icon, color: Colors.indigo),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  ...details
                      .map((d) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(d,
                                style: const TextStyle(fontSize: 15)),
                          ))
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Hasil Biodata"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoCard(Icons.person, "Data Diri", [
              "NISN : $nisn",
              "Nama : $nama",
              "Jenis Kelamin : $gender",
              "Agama : $agama",
              "Tanggal Lahir : $ttl",
              "No. HP : $telp",
              "NIK : $nik",
            ]),
            _buildInfoCard(Icons.home, "Alamat", [
              "Jalan : $jalan",
              "RT/RW : $rtRw",
              "Dusun : $dusun",
              "Kecamatan : $kecamatan",
              "Kabupaten : $kabupaten",
              "Provinsi : $provinsi",
              "Kode Pos : $kodePos",
            ]),
            _buildInfoCard(Icons.family_restroom, "Orang Tua / Wali", [
              "Nama Ayah : $ayah",
              "Nama Ibu : $ibu",
              "Nama Wali : $wali",
              "Alamat Wali : $alamatWali",
            ]),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              label: const Text("Kembali"),
            )
          ],
        ),
      ),
    );
  }
}
