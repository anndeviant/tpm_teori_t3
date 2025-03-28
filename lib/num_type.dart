import 'package:flutter/material.dart';

class NumType extends StatefulWidget {
  const NumType({super.key});

  @override
  State<NumType> createState() => _NumTypeState();
}

class _NumTypeState extends State<NumType> {
  final TextEditingController _controller = TextEditingController();
  bool _isNumber = false;
  bool _isPrime = false;
  bool _isDecimal = false;
  bool _isPositive = false;
  bool _isNegative = false;
  bool _isWhole = false;
  String _inputValue = "";

  void _checkNumberType() {
    setState(() {
      _inputValue = _controller.text.trim();

      // Reset all flags
      _isNumber = false;
      _isPrime = false;
      _isDecimal = false;
      _isPositive = false;
      _isNegative = false;
      _isWhole = false;

      // Check if input is a valid number
      try {
        double number = double.parse(_inputValue);
        _isNumber = true;

        // Check if positive or negative
        if (number > 0) {
          _isPositive = true;
        } else if (number < 0) {
          _isNegative = true;
        }

        // Check if decimal
        _isDecimal = number % 1 != 0;

        // Check if whole number (cacah)
        _isWhole = number >= 0 && number % 1 == 0;

        // Check if prime (only for positive integers)
        if (_isWhole && number > 1 && number % 1 == 0) {
          int intNumber = number.toInt();
          _isPrime = isPrime(intNumber);
        }
      } catch (e) {
        // Not a valid number
        _isNumber = false;
      }
    });
  }

  bool isPrime(int number) {
    if (number <= 1) return false;
    if (number <= 3) return true;
    if (number % 2 == 0 || number % 3 == 0) return false;

    int i = 5;
    while (i * i <= number) {
      if (number % i == 0 || number % (i + 2) == 0) return false;
      i += 6;
    }
    return true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            'Check Jenis Bilangan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Implement actual logout logic here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Logged out successfully')),
                          );
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Analisis Jenis Bilangan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/897/897368.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _controller,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          decoration: InputDecoration(
                            labelText: 'Masukkan Angka',
                            hintText: 'Contoh: 42, -5.7, 0, dll.',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.numbers),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _controller.clear();
                                setState(() {
                                  _isNumber = false;
                                  _inputValue = "";
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _checkNumberType,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Check Jenis Bilangan'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (_inputValue.isNotEmpty)
                  _isNumber
                      ? _buildResultsCard()
                      : Card(
                          color: Colors.red.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(Icons.error, color: Colors.red),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "'$_inputValue' bukan angka valid!",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildResultsCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Hasil Bilangan: $_inputValue',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            _buildResultRow('Bilangan Prima', _isPrime),
            _buildResultRow('Bilangan Desimal', _isDecimal),
            _buildResultRow('Bilangan Positif', _isPositive),
            _buildResultRow('Bilangan Negatif', _isNegative),
            _buildResultRow('Bilangan Cacah', _isWhole),
          ],
        ),
      ),
    );
  }

  _buildResultRow(String type, bool isTrue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            isTrue ? Icons.check_circle : Icons.cancel,
            color: isTrue ? Colors.green : Colors.red,
            size: 28,
          ),
          const SizedBox(width: 15),
          Text(
            type,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
