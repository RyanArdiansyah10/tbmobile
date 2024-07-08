import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'models/stok.dart';

class TambahStokPage extends StatefulWidget {
  @override
  _TambahStokPageState createState() => _TambahStokPageState();
}

class _TambahStokPageState extends State<TambahStokPage> {
  final _formKey = GlobalKey<FormState>();
  String _nama = '';
  int _kuantitas = 0;
  String _atribut = '';
  double _berat = 0.0;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Stok stok = Stok(
        id: '',
        name: _nama,
        qty: _kuantitas,
        attr: _atribut,
        weight: _berat,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      String apiUrl = 'https://api.kartel.dev/stocks';

      try {
        print('Data yang dikirim: ${stok.toJson()}');

        var response = await Dio().post(
          apiUrl,
          data: stok.toJson(),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal menambah stok: ${response.statusMessage}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Stok'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade800, Colors.teal.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  _buildTextField(
                    label: 'Nama',
                    onSaved: (value) => _nama = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Kuantitas',
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _kuantitas = int.parse(value!),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kuantitas tidak boleh kosong';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Kuantitas harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Atribut',
                    onSaved: (value) => _atribut = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Atribut tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Berat',
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onSaved: (value) => _berat = double.parse(value!),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Berat tidak boleh kosong';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Berat harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.indigo),
                        shape:
                            MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        padding:
                            MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                        ),
                        elevation: MaterialStateProperty.all<double>(10),
                        shadowColor: MaterialStateProperty.all<Color>(
                            Colors.indigoAccent),
                      ),
                      onPressed: _submitForm,
                      child: const Text('Submit',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.indigo, width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
    );
  }
}
