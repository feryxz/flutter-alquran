import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//CLASS INI SAMA DENGAN CLASS SEBELUMNYA, UNTUK MENG-HANDLE FORMAT DATA YANG DIINGINKAN
class QuranAyatModel {
  final int ayatId;
  final int ayatNumber;
  final int surahId;
  final int juzId;
  final String ayatArab;
  final String ayatText;

  QuranAyatModel({
    @required this.ayatId,
    @required this.ayatNumber,
    @required this.surahId,
    @required this.juzId,
    @required this.ayatArab,
    @required this.ayatText,
  });
}

//CLASS INI UNTUK MENG-HANDLE STATE MANAGEMENT
class QuranAyat with ChangeNotifier {
  List<QuranAyatModel> _data =
      []; //DATA CONTENT SURAH KITA BUAT BERTIPE LIST DENGAN FORMAT SESUAI DENGAN CLASS QuranAyatModel

  //KARENA URL MP3 TIDAK ADA DALAM API, MAKA KITA BUAT MANUAL. DIMANA URUTANNYA KITA SESUAIKAN DENGAN URUTAN SURAH
  //DATA INI MASIH BELUM LENGKAP, SILAHKAN DILENGKAPI
  List _mp3 = [
    'http://ia802609.us.archive.org/13/items/quraninindonesia/001AlFaatihah.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/002AlBaqarah.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/003AliImran.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/004AnNisaa.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/005AlMaaidah.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/006AlAnaam.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/007AlAaraaf.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/008AlAnfaal.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/009AtTaubah.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/010Yunus.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/011Huud.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/012Yusuf.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/013ArRaad.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/014Ibrahim.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/015AlHijr.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/016AnNahl.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/017AlIsraa.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/018AlKahfi.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/019Maryam.mp3',
    'http://ia802609.us.archive.org/13/items/quraninindonesia/020Thaahaa2.mp3'
  ];

  //GETTER AGAR VALUE _data BISA DIAKSES DARI LUAR CLASS
  List<QuranAyatModel> get items {
    return [..._data];
  }

  //MENGAMBIL URL MP3 BERDASARKAN ID SURAH
  String findMp3Url(id) {
    return _mp3[id -
        1]; //KARENA ID SURAH DIMULAI DARI 1 SEDANGKAN ARRAY DIMULAI DARI 0, MAKA KITA KURANGI 1 SETIAP ID SURAHNYA
  }

  //METHOD UNTUK MENGAMBIL ISI SURAH BERDASARKAN ID SURAH
  Future<void> getDetail(
      int id, int navigationBarIndex, int offset, int total) async {
    //PROSES REQUEST HANYA DIJALANKAN JIKA MEMENUHI KONDISI YANG ADA DI DALAM IF
    //HAL INI DILAKUKAN KARENA SETSTATE JUGA BERARTI AKAN MENJALANKAN FUNGSI INI KETIKA TOMBOL PLAY DITAP
    //AKAN TETAP KITA TIDAK INGIN MENJALANKAN FUNGSI INI JIKA BUKAN TOMBOL NEXT/PREVIOUS
    if ((navigationBarIndex == 2 && total == offset) ||
        (navigationBarIndex == 0 && total > offset)) {
      //GET DATA BERDASARKAN ID DAN OFFSET, DIMANA PER SEKALI LOAD KITA AMBIL 10 DATA
      final url =
          'https://quran.kemenag.go.id/index.php/api/v1/ayatweb/$id/0/$offset/10';
      final response = await http.get(url);
      final extractData = json.decode(response.body)['data']
          as List; //FORMAT DATA BERBENTUK LIST

      if (extractData == null) {
        return;
      }

      final List<QuranAyatModel> ayatData = [];
      //LOOPING DATA
      extractData.forEach((value) {
        //DAN MASUKKAN DATANYA SESUAI FORMAT QuranAyatModel
        ayatData.add(QuranAyatModel(
            ayatId: value['aya_id'],
            ayatNumber: value['aya_number'],
            surahId: value['sura_id'],
            juzId: value['juz_id'],
            ayatArab: value['aya_text'],
            ayatText: value['translation_aya_text']));
      });

      _data = ayatData; //TAMBAHKAN DATANYA KE DALAM _data
      notifyListeners();
    }
  }
}
