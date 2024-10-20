import 'dart:io';

import 'package:flour_mill/vendor/shopdetail.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flour_mill/vendor/models/shopregistration_model.dart';

class ShopRegistrationForm extends StatefulWidget {
  const ShopRegistrationForm({Key? key}) : super(key: key);

  @override
  State<ShopRegistrationForm> createState() => _ShopRegistrationFormState();
}

class _ShopRegistrationFormState extends State<ShopRegistrationForm> {
  //form key
  final _formKey = GlobalKey<FormState>();

  //text editing controllers
  final Map<String, TextEditingController> _textFieldControllers = {
    'Shop Name': TextEditingController(),
    'Owner\'s Name': TextEditingController(),
    'Phone Number': TextEditingController(),
    'Email': TextEditingController(),
    'Operating Hours': TextEditingController(),
    'Flours Available': TextEditingController(),
  };
  final Map<String, TextEditingController> _addressFieldControllers = {
    'Address': TextEditingController(),
    
  };
  

  // final _operatinghoursController = TextEditingController();
  // final _floursController = TextEditingController();

  final List<String> flourTypes = ['Wheat', 'Rice', 'Corn', 'Barley', 'Oats'];
  final List<bool> selectedFlourTypes = List.generate(5, (_) => false);
  //flour types
  List<String> getSelectedFlourTypes() {
    return flourTypes
        .asMap()
        .entries
        .where((entry) => selectedFlourTypes[entry.key])
        .map((entry) => entry.value)
        .toList();
  }

  //operating hours
  TimeOfDay _openingTime = TimeOfDay.now();
  TimeOfDay _closingTime = TimeOfDay.now();

  //image picker
  XFile? _selectedImage;
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shop Registration'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField('Shop Name'),
              _buildTextField('Owner\'s Name'),
              _buildTextField('Phone Number'),
              _buildTextField('Email'),
              _buildMultilineTextField('Address'),
              _buildFlourTypeSelection(),
              // _buildMultilineTextField('Types of Flours Available associated with price'),
              _buildOperatingHours(),
              // _buildMultilineTextField('Operating Hours'),
              _buildImagePicker('Upload Shop Image'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Register My Shop'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final shopRegistration = ShopRegistration(
        image: File(_selectedImage!.path),
        operatinghours:
            '${_openingTime.format(context)} - ${_closingTime.format(context)}',
        flours: getSelectedFlourTypes().join(', '),
        shopname: _textFieldControllers['Shop Name']!.text,
        ownername: _textFieldControllers['Owner\'s Name']!.text,
        phonenumber: _textFieldControllers['Phone Number']!.text,
        email:  _textFieldControllers['Email']!.text,
        address: _addressFieldControllers['Address']!.text,

        // Add other fields as needed
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ShopDetailsPage(shopRegistration: shopRegistration),
        ),
      );
    }
  }

  Widget _buildOperatingHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Operating Hours:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTimePicker('Opening Time', _openingTime, (newTime) {
                setState(() => _openingTime = newTime);
              }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTimePicker('Closing Time', _closingTime, (newTime) {
                setState(() => _closingTime = newTime);
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTimePicker(
      String label, TimeOfDay time, Function(TimeOfDay) onChanged) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null && picked != time) {
          onChanged(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(time.format(context)),
            Icon(Icons.access_time, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildFlourTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Flour Types:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...List.generate(flourTypes.length, (index) {
          return CheckboxListTile(
            title: Text(flourTypes[index]),
            value: selectedFlourTypes[index],
            onChanged: (bool? value) {
              setState(() {
                selectedFlourTypes[index] = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: _textFieldControllers[label],
        decoration: InputDecoration(
          labelText: label,
          // hintText: placeholder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  Widget _buildMultilineTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: _addressFieldControllers[label],
        maxLines: 3,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(String label) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: _pickImage,
            child: Text(label),
          ),
        ),
        if (_selectedImage != null) ...[
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.file(
              File(_selectedImage!.path),
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ],
    );
  }
}
