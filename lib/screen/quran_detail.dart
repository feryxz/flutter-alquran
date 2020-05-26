import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../models/quran_model.dart'; //IMPORT QURAN MODEL UNTUK MENGAMBIL DATA SURAH
import '../models/quran_ayat_model.dart'; //IMPORT MODEL BARU YANG NANTINYA AKAN KITA BUAT

import '../widget/quran_read.dart'; //CUSTOM WIDGET UNTUK MENAMPILKAN ISI SURAH

class QuranDetail extends StatefulWidget {
  @override
  _QuranDetailState createState() => _QuranDetailState();
}

class _QuranDetailState extends State<QuranDetail> {
  //VARIABLE INI UNTUK MENG-HANDLE BOTTOM NAVIGATION (PREVIOUS = 0, PLAY = 1 DAN NEXT = 2)
  //VALUE DEFAULTNYA KITA SET 2 (NEXT)
  int bottomIndex = 2;
  int offset = 0; //OFFSET UNTUK MENANDAI BERAPA DATA YANG SUDAH DI-LOAD
  int totalData = 0; //UNTUK MENYIMPAN INFORMASI ID DATA TERAKHIR YANG DI-LOAD
  int id; //ID SURAH
  bool isPlay = false; //VARIABLE UNTUK PLAY/STOP AUDIO
  AudioPlayer audioPlayer =
      AudioPlayer(); //VARIABLE YANG AKAN MENG-HANDLE AUDIO

  //METHOD UNTUK MENJALANKAN AUDIO DARI SURAH YANG DIPILIH
  void play() async {
    //JIKA isPlay = false
    if (!isPlay) {
      //MAKA KITA AMBIL URL DARI SURAH TERKAIT MENGGUNAKAN METHOD findMp3Url DENGAN MENGIRIMKAN ID SURAH
      final mp3URL =
          Provider.of<QuranAyat>(context, listen: false).findMp3Url(id);
      int result = await audioPlayer.play(mp3URL); //PLAY AUDIONYA
      if (result == 1) {
        //JIKA BERHASIL DIPLAY
        setState(() {
          isPlay = true; //MAKA SET VARIABLE NYA JADI TRUE
        });
      }
    } else {
      //JIKA ISPLAY = TRUE MAKA KITA JALANKAN FUNGSI STOP AUDIO
      int result = await audioPlayer.stop();
      if (result == 1) {
        setState(() {
          isPlay = false; //DAN SET isPlay JADI FALSE
        });
      }
    }
  }

  //KETIKA BOTTOM NAVIGATION DI-TAP MAKA AKAN MENJALANKAN FUNGSI INI
  void _changeBottomIndex(index) {
    //DI-CEK INDEX YANG DI-TAP, JIKA VALUE-NYA 1 (TOMBOL PLAY)
    if (index == 1) {
      play(); //MAKA KITA JALANKAN METHOD play()
    }

    //AMBIL DATA TERBARU YANG ADA DI CLASS QuranAyat DENGAN PROPERTY items
    final loadData = Provider.of<QuranAyat>(context, listen: false).items;
    //KEMUDIAN KITA AMBIL NOMOR SURAH DARI DATA YANG TERAKHIR
    totalData =
        loadData.length > 0 ? loadData[loadData.length - 1].ayatNumber : 0;

    //JIKA INDEX 0 (PREVIOUS)
    if (index == 0) {
      //OFFSET KITA KURANGI KARENA AKAN KEMBALI KE DATA SEBELUMNYA
      offset -= totalData == offset ? (loadData.length * 2) : loadData.length;
    } else if (index == 2) {
      //JIKA INDEX 2 (NEXT), MAKA OFFSET KITA TAMBAH KARENA AKAN KE DATA BERIKUTNYA
      offset += totalData == offset ? (loadData.length * 2) : loadData.length;
    }

    setState(() {
      bottomIndex =
          index; //SET STATE UNTUK MEMBERITAHU BAHWA ADA PERUBAHAN MAKA WIDGET AKAN DIRENDER KEMBALI
    });
  }

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context).settings.arguments
        as int; //DAPATKAN ARGUMEN YANG DIKIRIMKAN DARI PAGE SEBELUMNYA
    //KEMUDIAN CARI DATA BERDASARKAN ID SURAH YANG DITERIMA
    final data = Provider.of<QuranData>(context, listen: false).findById(id);

    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Feryxz Dev Al-Qur'an"),
              Text(
                '${data.name} - ${data.arab}',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(5),
          //PERHATIKAN BAGIAN SEBELUMNYA, KITA TIDAK MENGGUNAKAN FUNGSI getDetail()
          //KARENA FUTURE BUILDER SECARA OTOMATIS AKAN BERJALAN KETIKA SCREEN DI-LOAD
          //DAN KETIKA USER TAP NEXT / PREVIOUS, KITA MENGGUNAKAN SET STATE YANG BERARTI WIDGET DI RE-RENDER, MAKA FUTURE BUILDER AKAN DIJALANKAN KEMBALI
          child: FutureBuilder(
            future: Provider.of<QuranAyat>(context, listen: false).getDetail(
                id,
                bottomIndex,
                offset,
                totalData), //SECARA OTOMATIS FUNGSI INI AKAN DIJALANKAN SETIAP KALI WIDGET BERUBAH UNTUK MENGAMBIL DATA BERDASARKAN ID SURAH, INDEX BOTTOM NAVIGATION DAN OFFSET YANG DI-REQUEST
            builder: (context, snapshot) {
              //KETIKA PROSES REQUEST BERLANGSUNG
              if (snapshot.connectionState == ConnectionState.waiting) {
                //MAKA PROGRESS LOADING DIJALANKAN
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                //JIKA TERJADI ERROR
                if (snapshot.hasError) {
                  //MAKA INFORMASI ERROR DI RENDER
                  return Center(
                    child: Text("Error! Periksa Koneksi Anda"),
                  );
                } else {
                  //SELAIN ITU MAKA KITA RENDER ISI SURAH TERKAIT
                  return Consumer<QuranAyat>(
                    //MENGGUNAKAN CONSUMER UNTUK MENGAMBIL DATA STATE DAN LIST VIEW UNTUK RENDER CONTENT-NYA
                    builder: (ctx, data, _) => ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.items
                          .length, //LIST VIEW AKAN DIJALANKAN BERDASARKAN JUMLAH DATA
                      //LAGI LAGI KITA GUNAKAN CUSTOM WIDGET AGAR CODINGAN DIFILE INI TIDAK PANJANG, CLASS QuranRead() AKAN DIBUAT SELANJUTNYA.
                      itemBuilder: (ctx, i) => QuranRead(
                        data.items[i].ayatNumber,
                        data.items[i].ayatArab,
                        data.items[i].ayatText,
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ),
        //BOTTOM NAVIGATION NYA KITA BUAT DISINI
        bottomNavigationBar: BottomNavigationBar(
          //DIMANA INDEXNYA SESUAI DENGAN BOTTOMINDEX
          currentIndex: bottomIndex,
          //DAN ITEMSNYA ADALAH 3, PREVIOUS, PLAY DAN NEXT
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.arrow_left), title: Text('Previous')),
            BottomNavigationBarItem(
                icon: Icon(isPlay ? Icons.stop : Icons.play_arrow),
                title: Text('${!isPlay ? "Play" : "Stop"}')),
            BottomNavigationBarItem(
                icon: Icon(Icons.arrow_right), title: Text('Next')),
          ],
          //KETIAK DI-TAP MAKA AKAN MENJALANKAN FUNGSI _changeBottomIndex
          onTap: _changeBottomIndex,
        ));
  }
}
