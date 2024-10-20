import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flour_mill/const/loading_overly.dart';
import 'package:flour_mill/vendor/shopdetail.dart';
import 'package:flour_mill/vendor/vendor_homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flour_mill/vendor/models/shopregistration_model.dart';

class ShopRegistrationForm extends StatefulWidget {
  final String? email;
  final String? name;
  const ShopRegistrationForm({Key? key, this.email, this.name}) : super(key: key);

  @override
  State<ShopRegistrationForm> createState() => _ShopRegistrationFormState();
}

class _ShopRegistrationFormState extends State<ShopRegistrationForm> {
 
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _textControllers = {
    'Shop Name': TextEditingController(),
    'Owner\'s Name': TextEditingController(),
    'Phone Number': TextEditingController(),
    'Email': TextEditingController(),
    'Address': TextEditingController(),
  };
  
  final List<FlourType> _flourTypes = [
    FlourType(name: 'Wheat Flour', price: 0),
    FlourType(name: 'Rice Flour', price: 0),
    FlourType(name: 'Corn Flour', price: 0),
    FlourType(name: 'Plain Flour', price: 0),
    FlourType(name: 'Barley Flour', price: 0),
  ];

  final LoadingOverlay _loadingOverlay = LoadingOverlay();

  bool _isLoading = false;
  TimeOfDay _openingTime = TimeOfDay.now();
  TimeOfDay _closingTime = TimeOfDay.now();
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.email != null) _textControllers['Email']?.text = widget.email!;
    if (widget.name != null) _textControllers['Owner\'s Name']?.text = widget.name!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shop Registration'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ..._buildTextFields(),
                      _buildFlourTypeSelection(),
                      _buildOperatingHours(),
                      _buildImagePicker(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Register My Shop'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTextFields() {
    return _textControllers.entries.map((entry) {
      final isMultiline = entry.key == 'Address';
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
          controller: entry.value,
          decoration: InputDecoration(
            labelText: entry.key,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          maxLines: isMultiline ? 3 : 1,
          keyboardType: entry.key == 'Phone Number' ? TextInputType.phone : TextInputType.text,
          inputFormatters: entry.key == 'Phone Number'
              ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)]
              : null,
          validator: (value) => _validateField(entry.key, value),
        ),
      );
    }).toList();
  }

  Widget _buildFlourTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Flour Types and Prices:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ..._flourTypes.map(_buildFlourTypeRow),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFlourTypeRow(FlourType flourType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: flourType.price > 0,
            onChanged: (bool? value) {
              setState(() => flourType.price = value == true ? 1 : 0);
            },
          ),
          Expanded(flex: 2, child: Text(flourType.name)),
          Expanded(
            flex: 3,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Price',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              initialValue: flourType.price > 0 ? flourType.price.toString() : '',
              onChanged: (value) => setState(() => flourType.price = double.tryParse(value) ?? 0),
              validator: (value) => flourType.price > 0 && (value == null || value.isEmpty) ? 'Please enter a price' : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperatingHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Operating Hours:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(child: _buildTimePicker('Opening Time', _openingTime, (newTime) => setState(() => _openingTime = newTime))),
              const SizedBox(width: 16),
              Expanded(child: _buildTimePicker('Closing Time', _closingTime, (newTime) => setState(() => _closingTime = newTime))),
            ],
          ),
        ),
        if (!_isValidOperatingHours())
          const Text('If opening time is AM, closing time must be PM', style: TextStyle(color: Colors.red, fontSize: 12)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay time, Function(TimeOfDay) onChanged) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(context: context, initialTime: time);
        if (picked != null && picked != time) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(time.format(context)),
            const Icon(Icons.access_time, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: _pickImage,
              child: const Text('Upload Shop Image'),
            ),
          ),
          if (_selectedImage != null) ...[
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.file(File(_selectedImage!.path), width: 40, height: 40, fit: BoxFit.cover),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _selectedImage = image);
  }

  String? _validateField(String label, String? value) {
    if (value == null || value.isEmpty) return 'Please enter $label';
    if (label == 'Phone Number' && value.length != 10) return 'Phone number must be 10 digits';
    return null;
  }

  bool _isValidOperatingHours() {
    return _openingTime.period == DayPeriod.am && _closingTime.period == DayPeriod.pm ||
           _openingTime.period == DayPeriod.pm || _closingTime.period == DayPeriod.am;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _isValidOperatingHours()) {
      setState(() => _isLoading = true);
    _loadingOverlay.show(context);

      try {
        if (_selectedImage == null) throw Exception('Please select a shop image');

        final selectedFlourTypes = _flourTypes.where((ft) => ft.price > 0).toList();
        if (selectedFlourTypes.isEmpty) throw Exception('Please select at least one flour type with a price');

        final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('shop_images/$fileName');
        final UploadTask uploadTask = firebaseStorageRef.putFile(File(_selectedImage!.path));
        final TaskSnapshot taskSnapshot = await uploadTask;
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        final User? user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception('No user signed in');

        // Get and increment the user ID counter
        // final int userId = await _getNextUserId();

        final shopData = {
          'shopname': _textControllers['Shop Name']!.text,
          'ownername': _textControllers['Owner\'s Name']!.text,
          'phonenumber': _textControllers['Phone Number']!.text,
          'email': _textControllers['Email']!.text,
          'address': _textControllers['Address']!.text,
          'operatinghours': '${_openingTime.format(context)} - ${_closingTime.format(context)}',
          'flourTypes': selectedFlourTypes.map((ft) => {
            'name': ft.name,
            'price': ft.price.toDouble(), // Ensure price is stored as a double
          }).toList(),
          'imageUrl': downloadUrl,
          'userType': 'provider',
          'createdAt': FieldValue.serverTimestamp(),
          // 'userId': userId.toString().padLeft(7, '0'),
          // 'firebaseUserId': user.uid,
        };

        // Validate all fields are non-null and non-empty
        shopData.forEach((key, value) {
          if (value == null || (value is String && value.isEmpty)) {
            throw Exception('$key cannot be empty');
          }
        });

        final docRef = await FirebaseFirestore.instance.collection('Providers').doc(user.uid).set(shopData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shop registered successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VendorHomepage(shopData:shopData),
            // ShopDetailsPage(
            //   shopRegistration: ShopRegistration(
            //     image: File(_selectedImage!.path),
            //     operatinghours: shopData['operatinghours'] as String,
            //     shopname: shopData['shopname'] as String,
            //     ownername: shopData['ownername'] as String,
            //     phonenumber: shopData['phonenumber'] as String,
            //     email: shopData['email'] as String,
            //     address: shopData['address'] as String,
            //     flourTypes: selectedFlourTypes,
            //     imageUrl: downloadUrl,
            //     userType: 'provider',
            //     createdAt: DateTime.now(),
            //   ),
            // ),
          ),
        );
      } catch (e) {
      _loadingOverlay.hide();
       
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
      _loadingOverlay.hide();
        if (mounted) setState(() => _isLoading = false);
      }
    } else if (!_isValidOperatingHours()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid operating hours. If opening time is AM, closing time must be PM')),
      );
    }
  }
}





