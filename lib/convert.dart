import 'package:flutter/material.dart';

class Convert extends StatefulWidget {
  const Convert({super.key});

  @override
  State<Convert> createState() => _ConvertState();
}

const List<String> list = <String>['Jam', 'Menit', 'Detik'];

class _ConvertState extends State<Convert> {
  String dropdownValue = list.first;
  int hasil = 0;
  final yearController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error!'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  isleap(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  void convert() {
    int? year = int.tryParse(yearController.text);
    if (yearController.text.isEmpty) {
      year = 0;
    }
    if (year == null) {
      _showErrorDialog('Input harus angka');
      return;
    }
    int result = 0;

    if (year > 0) {
      int days = isleap(year) ? 366 : 365;
      switch (dropdownValue) {
        case 'Jam':
          result = days * 24;
          break;
        case 'Menit':
          result = days * 24 * 60;
          break;
        case 'Detik':
          result = days * 24 * 60 * 60;
          break;
      }
    }

    setState(() {
      hasil = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text("Konverter Tahun"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(label: Text("Tahun")),
                onChanged: (value) => convert(),
              ),
              Divider(thickness: 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    value: dropdownValue,
                    elevation: 16,
                    style:
                        const TextStyle(color: Colors.deepPurple, fontSize: 15),
                    underline:
                        Container(height: 1, color: Colors.deepPurpleAccent),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                        convert();
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                  ),
                  Text(
                    "Hasil : $hasil $dropdownValue",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  Divider(thickness: 2),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
