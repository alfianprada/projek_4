// lib/result_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultPage extends StatelessWidget {
  final String nisn, nama, jenisKelamin, agama, tglLahir, hp, nik;
  final String jalan, rtRw, dusun, desa, kecamatan, kabupaten, provinsi, kodePos;
  final String ayah, ibu, wali, alamatWali;

  const ResultPage({
    super.key,
    required this.nisn,
    required this.nama,
    required this.jenisKelamin,
    required this.agama,
    required this.tglLahir,
    required this.hp,
    required this.nik,
    required this.jalan,
    required this.rtRw,
    required this.dusun,
    required this.desa,
    required this.kecamatan,
    required this.kabupaten,
    required this.provinsi,
    required this.kodePos,
    required this.ayah,
    required this.ibu,
    required this.wali,
    required this.alamatWali,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Biodata', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF5B2DF9),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          _cardSection('Data Diri', Icons.person, [
            'NISN : $nisn',
            'Nama : $nama',
            'Jenis Kelamin : $jenisKelamin',
            'Agama : $agama',
            'Tanggal Lahir : $tglLahir',
            'No. HP : $hp',
            'NIK : $nik',
          ]),
          _cardSection('Alamat', Icons.home, [
            'Jalan : $jalan',
            'RT/RW : $rtRw',
            'Dusun : $dusun',
            'Desa : $desa',
            'Kecamatan : $kecamatan',
            'Kabupaten : $kabupaten',
            'Provinsi : $provinsi',
            'Kode Pos : $kodePos',
          ]),
          _cardSection('Orang Tua / Wali', Icons.group, [
            'Nama Ayah : $ayah',
            'Nama Ibu : $ibu',
            'Nama Wali : $wali',
            'Alamat Wali : $alamatWali',
          ]),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: Text('Kembali', style: GoogleFonts.poppins()),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B2DF9)),
          ),
        ]),
      ),
    );
  }

  Widget _cardSection(String title, IconData icon, List<String> rows) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(icon, color: const Color(0xFF7C4DFF)), const SizedBox(width: 8), Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700))]),
          const Divider(),
          ...rows.map((r) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(r, style: GoogleFonts.poppins()))),
        ]),
      ),
    );
  }
}
