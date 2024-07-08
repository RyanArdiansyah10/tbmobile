import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'models/stok.dart';

class EditStokForm extends StatefulWidget {
  final Stok stok;

  EditStokForm({required this.stok});

  @override
  _EditStokFormState createState() => _EditStokFormState();
}

class _EditStokFormState extends State<EditStokForm> {
  final _formKey = GlobalKey<FormState>();
  late String _nama;
  late int _kuantitas;
  late String _atribut;
  late double _berat;

  @override
  void initState() {
    super.initState();
    _nama = widget.stok.name;
    _kuantitas = widget.stok.qty;
    _atribut = widget.stok.attr;
    _berat = widget.stok.weight;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Stok updatedStok = Stok(
        id: widget.stok.id,
        name: _nama,
        qty: _kuantitas,
        attr: _atribut,
        weight: _berat,
        createdAt: widget.stok.createdAt,
        updatedAt: DateTime.now(),
      );

      String apiUrl = 'https://api.kartel.dev/stocks/${widget.stok.id}';

      try {
        print('Data yang dikirim: ${updatedStok.toJson()}');

        var response = await Dio().put(
          apiUrl,
          data: updatedStok.toJson(),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        );

        if (response.statusCode == 200 || response.statusCode == 204) {
          Navigator.pop(context, true);
        } else if (response.statusCode == 422) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui stok: ${response.data}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal memperbarui stok: ${response.statusMessage}')),
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
        title: const Text('Edit Stok'),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField(
                label: 'Nama',
                initialValue: _nama,
                onSaved: (value) => _nama = value!,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Kuantitas',
                initialValue: _kuantitas.toString(),
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
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Atribut',
                initialValue: _atribut,
                onSaved: (value) => _atribut = value!,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Atribut tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Berat',
                initialValue: _berat.toString(),
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
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text('Submit', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onSaved: onSaved,
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
