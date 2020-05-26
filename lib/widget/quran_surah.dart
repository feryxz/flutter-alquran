import 'package:flutter/material.dart';

class QuranSurah extends StatelessWidget {
  //DEFINISIKAN VARIABLE APA SAJA YANG DIBUTUHKAN UNTUK INFORMASI SURAH
  final int id;
  final String name;
  final String arab;
  final String translate;
  final int countAyat;

  //BUAT CONSTRUCTOR UNTUK MEMINTA DATA KETIKA CLASS INI DI-LOAD
  QuranSurah(this.id, this.name, this.arab, this.translate, this.countAyat);

  //BUAT METHOD UNTUK REDIRECT KE SCREEN BARU
  //FUNGSI INI NANTINYA DIGUNAKAN UNTUK BERPINDAH KE DETAIL MASING-MASING SURAH
  //DIMANA KETIKA SURAH TERSEBUT DITAP MAKA AKAN PINDAH KE SCREEN DETAIL
  void _viewDetail(BuildContext context) {
    Navigator.of(context).pushNamed('/detail',
        arguments:
            id); //MENGGUNAKAN NAVIGATOR DAN MENUJU ROUTES /detail DIMANA ROUTE INI BELUM DIDEFINISIKAN
    //ROUTE DIATAS AKAN DIDEFINISIKAN KEMUDIAN. SELAIN ITU KITA MENGIRIMKAN ID SURAH SEBAGAI ARGUMENT YANG NANTINYA DIGUNAKAN OLEH SCREEN YANG BARU UNTUK MENGAMBIL DATA SURAH TERKAIT
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        //KETIKA LISTTILE DITAP, MAKA AKAN MENJALANKAN METHOD DIATAS
        onTap: () => _viewDetail(context),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //MULAI DARI SINI HINGGA CODE DIBAWAH HANYA MENAMPILKAN INFORMASI SURAH
        //LEADING POSISINYA SEBELAH KIRI, DIMANA KITA GUNAKAN UNTUK MENAMPILKAN NOMOR URUT SURAH
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1, color: Colors.black),
            ),
          ),
          child: CircleAvatar(
            child: Text('$id'),
          ),
        ),
        //TITLE POSISINYA DITENGAH, KITA GUNAKAN UNTUK MENAMPILKAN NAMA SURAH (LENGKAP DENGAN BAHASA ARABNYA)
        title: Text(
          '$name ($arab)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        //DAN SUBTITLE POSISINYA DIBAWAH TITLE UNTUK MENAMPILKAN INFORMASI TAMBAHAN
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //PERTAMA ADALAH TERJEMAHAN DARI NAMA SURAH
            Row(
              children: <Widget>[
                Icon(
                  Icons.local_florist,
                  color: Colors.blueAccent,
                ),
                Expanded(child: Text('Terjemahan: $translate')),
              ],
            ),
            //JUMLAH AYAT DARI SURAH TERSEBUT
            Row(
              children: <Widget>[
                Icon(
                  Icons.local_florist,
                  color: Colors.blueAccent,
                ),
                Text('Jumlah Ayat: $countAyat'),
              ],
            ),
          ],
        ),
        //POSISINYA PALING KANAN, KITA GUNAKAN UNTUK MENAMPILKAN ICON SAJA
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
        ),
      ),
    );
  }
}
