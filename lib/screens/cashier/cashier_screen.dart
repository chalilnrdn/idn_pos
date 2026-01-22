import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:idn_pos/models/products.dart';
import 'package:permission_handler/permission_handler.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  bool _connected = false;
  final Map<Product, int> _cart = {};

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  //untuk logika bluetooth
  Future<void> _initBluetooth() async {
    // minta izin lokasi & bluetooth #iziin
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location
    ].request();

    List<BluetoothDevice> devices = [];
    // list ini akan otomatis terisi jika bt di handphone menyala dan sudah ada device yang siap dikoenksikan
    try {
      devices = await bluetooth.getBondedDevices();
    } catch (e) {
      debugPrint("Error Bluetooth: $e");
    }

    //kalo bluetooth udah ready
    if (mounted) {
      setState(() {
        _devices = devices;
      });
    }
    
    bluetooth.onStateChanged().listen((state) {
      if (mounted) {
        setState(() {
          _connected = state == BlueThermalPrinter.CONNECTED;
        });
      }
    });
  }

  void _connectToDevice(BluetoothDevice? device) {
    //kondisi utama yang mempelopori if-if selanjutnya
    if (device != null) { //kalo device nya udah ada dan ga kosong (ada listnya di hp)
      bluetooth.isConnected.then((isConnected) { //buat mastiin bluetoothnya connect apa engga
        //if disini merupakan cabang dari kondisi utama, dan if ini memiliki kondisi yang menjawab statement dari kondisi utama
        if (isConnected == false) { //kalo bluetoothnya ga connect
          bluetooth.connect(device).catchError((error) {
            //if ini wajib punya opini yang sama seperti if kedua
            if (mounted) setState(() => _connected = false); 
          });

        //statement didalam if ini akan dijalankan ketika if if sebelumnya tidak terpenuhi
        //iff ini adalah opsi terakhir yang akan dijalankan ketika if-if sebelumnya tidak terpenuhi
        if (mounted) setState(() => _selectedDevice = device); //kode ini bakal jalan kalo device udah ke connect
        }
      });
    }
  }

  //logika untuk menambah produk ke keranjang
  void _addToCart(Product product) {
    setState(() {
      _cart.update(
      product, //untuk mendefinisakn product yang ada di menu
      (value) => value + 1, //ketika user udah milih item dan sudah tersedia di cart, dan user klik plus maka jumlahnya akan bertambah 1 
      ifAbsent: () => 1 //kalo dia ga ada lagi yang ditambah dari value, maka hasilnya akan segitu
      ); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}