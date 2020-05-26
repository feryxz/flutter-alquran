import 'package:flutter/material.dart';

class QuranRead extends StatelessWidget {
  //DEFINISIKAN VARIABLE DARI INFORMAIS YANG DIBUTUHKAN
  final int ayatNumber;
  final String ayatArab;
  final String ayatText;

  //BUAT CONSTRUCTOR UNTUK MEMINTA DATA
  QuranRead(this.ayatNumber, this.ayatArab, this.ayatText);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          child: Text('$ayatNumber'),
        ), //POSISI KIRI KITA TAMPILKAN NOMOR AYAT
        //DITENGAH KITA TAMPILKAN TEXT ARABNYA
        title: Text(
          '$ayatArab',
          textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        //DIBAWAH TITLE TAMPILKAN TERJEMAHANNYA
        subtitle: Text('$ayatText'),
      ),
    );
  }
}
