import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//CLASS INI AKAN MENG-HANDLE FORMAT DATA YANG DIINGINKAN
class Quran {
  //DEFINISIKAN VARIABLENYA BESERTA TIPE DATANYA
  final int id;
  final String name;
  final String arab;
  final String translate;
  final int countAyat;

  //BUAT CONSTRUCTOR DIMANA KETIKA CLASS INI DI-LOAD MAKA WAJIB MENGIRIMKAN DATA YANG DIMINTA
  Quran(
      {@required this.id,
      @required this.name,
      @required this.arab,
      @required this.translate,
      @required this.countAyat});
}

//CLASS INI DIGUNAKAN UNTUK STATE MANAGEMENT PROVIDER
class QuranData with ChangeNotifier {
  Quran findById(int id) {
    return _data
        .firstWhere((item) => item.id == id); //GET DATA SURAH BERDASARKAN ID
  }

  //DEFINISIKAN VARIABLE _data DENGAN TIPE LIST DAN FORMAT QURAN DIMANA NILAI DEFAULT ADA EMPTY ARRAY
  List<Quran> _data = [];
  int offset =
      0; //DEFINISIKAN VARIABLE offset DENGAN TIPE int DAN VALUE AWAL ADALAH 0

  //KARENA _data ADALAH PRIVATE PROPERTY DITANDAI DENGAN AWAL _
  //MAKA KITA BUAT GETTER AGAR _data BISA DIAKSES DARI LUAR CLASS
  //DAN GETTERNYA DIBERI NAMA items
  List<Quran> get items {
    return [..._data];
  }

  //FUNGSI getData() DIGUNAKAN UNTUK REQUEST LIST DATA SURAH YANG ADA
  Future<void> getData() async {
    try {
      //REQUEST KE SERVER HANYA DIJALANKAN JIKA OFFSET SAMA DENGAN TOTAL DATA YANG ADA
      if (offset == _data.length) {
        //URL TEMPAT KITA MENGAMBIL DATA SURAH, DIMANA OFFSET NILAINYA TERGANTUNG BERAPA BANYAK DATA YANG SUDAH DI-LOAD
        final url =
            'https://quran.kemenag.go.id/index.php/api/v1/surat/${offset}/10';
        //MINTA DATA KE API
        final response = await http.get(url);
        //CONVER DATA NYA MENJADI LIST
        final extractData = json.decode(response.body)['data'] as List;
        //JIKA DATANYA KOSONG
        if (extractData == null || extractData.length == 0) {
          return; //MAKA HENTIKAN FUNGSI
        }

        final List<Quran> quranData =
            []; //BUAT VARIABLE SEMENTARA UNTUK MENAMPUNG DATA
        //LOOPING DATA YANG SUDAH DI CONVERT
        extractData.forEach((value) {
          //TAMBAHKAN DATA TERSEBUT KE DALAM VARIABLE SEMENTARANYA
          //DENGAN FORMAT SESUAI DENGAN CLASS Quran()
          quranData.add(Quran(
              id: value['id'],
              name: value['surat_name'],
              arab: value['surat_text'],
              translate: value['surat_terjemahan'],
              countAyat: value['count_ayat']));
        });

        offset +=
            quranData.length; //UBAH VALUE OFFSET DENGAN MENAMBAHKAN DATA BARU
        _data.addAll(quranData); //INSERT DATA BARU KE DALAM VARIABLE _data
        notifyListeners(); //INFORMASIKAN JIKA TERJADI PERUBAHAN
      }
    } catch (error) {
      throw error;
    }
  }
}
