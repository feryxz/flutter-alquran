import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quran_model.dart';
import '../widget/quran_surah.dart';

class QuranList extends StatefulWidget {
  @override
  _QuranListState createState() => _QuranListState();
}

class _QuranListState extends State<QuranList> {
  ScrollController
      controller; //VARIABLE controller INI BER-TIPE SCROLLCONTROLLER YANG AKAN DIGUNAKAN UNTUK MENDETEKSI EVENT SCROLL PADA LAYAR

  //DEFINISIKAN VARIABLE LAINNYA YANG AKAN DIGUNAKAN UNTUK MENAMPILKAN DATA / PROGRESS LOADING
  bool loadMore = false;
  bool firstLoad = true;

  // HOOKS KETIKA CLASS INI DI-RENDER MAKA AKAN MENJALAN FUNGSI YANG DI-APITNYA
  @override
  void initState() {
    //UNTUK MENJALANKAN FUNGSI PROVIDER DIDALAM INITSTATE, MAKA KITA MEMBUTUHKAN PENUNDAAN MENGGUNAKAN FUTURE.DELAYED, DAN DURASINYA KITA SET KE 0
    Future.delayed(Duration.zero).then((_) {
      //LOAD PROVIDER YANG DITAUTKAN DENGAN QURANDATA (BERASAL DARI QURAN_MODEL.DART)
      // KEMUDIAN DIAKHIR KITA JALANKAN FUNGSI getData() YANG NANTINYA AKAN KITA BUAT
      Provider.of<QuranData>(context, listen: false).getData().then((_) {
        //KEMUDIAN SET firstLoad MENJADI FALSE
        setState(() {
          firstLoad = false;
        });
      });
    });
    super.initState();
    controller = ScrollController()
      ..addListener(_scrollListener); //TAMBAHKAN LISTENER SCROLLING
  }

  //KETIKA CLASS INI DITINGGALKAN
  @override
  void dispose() {
    //MAKA HAPUS LISTENER SCROLLING
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  //ADD LISTENER DAN REMOVE LISTENER MASING-MASING MEMANGGIL METHOD _scrollListener
  //KITA DEFINISIKAN METHOD TERSEBUT
  void _scrollListener() {
    //CEK JIKA POSISI = MAX SCROLL (MENTOK PALING BAWAH)
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      //MAKA SET loadMore JADI TRUE
      setState(() {
        loadMore = true;
      });

      //DAN JALANKAN FUNGSI getData() DARI QURAN_MODEL.DART
      Provider.of<QuranData>(context, listen: false).getData().then((_) {
        //JIKA BERHASIL, MAKA SET loadMore JADI FALSE
        setState(() {
          loadMore = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //BUAT APPBAR UNTUK HEAD APPS
      appBar: AppBar(
        leading: const Icon(Icons.book),
        title: const Text("Feryxz Dev - Al-Qur'an"),
      ),
      //FLOATING BUTTON KITA GUNAKAN UNTUK MENAMPILKAN PROGRESS LOADING
      floatingActionButton: loadMore ? CircularProgressIndicator() : null,
      body: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        //KETIKA PERTAMA KALI DILOAD MAKA KITA GUNAKAN LOADING DITENGAH LAYAR
        //NAMUN LOAD DATA SELANJUTNYA KITA GUNAKAN LOAD DI POJOK KANAN LAYAR
        //AGAR TIDAK MENGGANGGU PENGGUNA
        child: firstLoad
            ? Center(
                child: CircularProgressIndicator(),
              )
            //DETEKSI PERUBAHAN DATA MENGGUNAKAN CONSUMER
            //SEHINGGA WIDGET YANG DI-RENDER HANYA WIDGET YANG DIAPIT-NYA
            : Consumer<QuranData>(
                //SETIAP DATANYA KITA BUILD MENGGUNAKAN LISTVIEW AGAR BISA DI SCROLL
                builder: (ctx, data, _) => ListView.builder(
                  controller: controller, //SET CONTROLLER YANG DIBUAT DIAWAL
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: data.items
                      .length, //HITUNG JUMLAH DATA, MAKA LISTVIEW AKAN ME-RNDER SEBANYAK JUMLAH DATA
                  //RENDER DATANYA KE DALAM CUSTOM WIDGET BERNAMA QuranSurah() YANG SELANJUTNYA AKAN KITA BUAT
                  itemBuilder: (ctx, i) => QuranSurah(
                    //KIRIM DATA YANG DIBUTUHKAN
                    data.items[i].id,
                    data.items[i].name,
                    data.items[i].arab,
                    data.items[i].translate,
                    data.items[i].countAyat,
                  ),
                ),
              ),
      ),
    );
  }
}
