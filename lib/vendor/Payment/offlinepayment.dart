import 'package:flour_mill/Screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OfflinePaymentPage extends StatefulWidget {
  // final double suggestedAmount;
  final double totalAmount;
  final VoidCallback onPaymentSuccess;


  const OfflinePaymentPage({Key? key,
  //  required this.suggestedAmount,
   required this.totalAmount,
   required this.onPaymentSuccess,  
   })
      : super(key: key);

  @override
  _OfflinePaymentPageState createState() => _OfflinePaymentPageState();
}

class _OfflinePaymentPageState extends State<OfflinePaymentPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPaymentMethod = '';
  final _nameController = TextEditingController();
  final _upiController = TextEditingController();
  final _accNumberController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCVVController = TextEditingController();
  final _amountController = TextEditingController();
  final _cardNameController = TextEditingController();
  late BuildContext _scaffoldContext;

  

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'PhonePe', 'icon': Icons.phone_android},
    {'name': 'Google Pay', 'icon': Icons.g_mobiledata},
    {'name': 'Card', 'icon': Icons.credit_card},
    {'name': 'Bank Transfer', 'icon': Icons.account_balance},
  ];

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.totalAmount.toStringAsFixed(2);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldContext = context;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _upiController.dispose();
    _accNumberController.dispose();
    _ifscCodeController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCVVController.dispose();
    _amountController.dispose();
    _cardNameController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 10)),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      setState(() {
        _cardExpiryController.text =
            "${picked.month.toString().padLeft(2, '0')}/${picked.year.toString().substring(2)}";
      });
    }
  }

  void _submitPayment() {
    if (_formKey.currentState!.validate() &&
        _selectedPaymentMethod.isNotEmpty) {
      if (_selectedPaymentMethod == 'PhonePe' ||
          _selectedPaymentMethod == 'Google Pay') {
        _showUPIConfirmation();
      } else if (_selectedPaymentMethod == 'Card' || 
                 _selectedPaymentMethod == 'Bank Transfer') {
        _processPayment();
      }
    } else if (_selectedPaymentMethod.isEmpty) {
      ScaffoldMessenger.of(_scaffoldContext).showSnackBar(
        SnackBar(content: Text('Please select a payment method')),
      );
    }
  }

  void _showUPIConfirmation() {
    showDialog(
      context: _scaffoldContext,
      builder: (context) => AlertDialog(
        title: Text('Enter UPI PIN'),
        content: TextField(
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 6,
          decoration: InputDecoration(
            hintText: 'Enter 6-digit UPI PIN',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _processPayment();
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<bool> _processPayment() async {
    try {
      // Show loading indicator
      showDialog(
        context: _scaffoldContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      // Simulate payment processing
      await Future.delayed(Duration(seconds: 2));
      
      // Close loading indicator
      Navigator.of(_scaffoldContext).pop();

      // Show success dialog
      await _showPaymentConfirmationDialog();
      return true;
    } catch (e) {
      // Close loading indicator if it's still showing
      Navigator.of(_scaffoldContext).pop();
      
      print(e);
      _showPaymentFailureMessage();
      return false;
    }
  }

  Future<void> _showPaymentConfirmationDialog() async {
    await showDialog(
      context: _scaffoldContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Successful'),
          content: Text('Your payment has been processed successfully.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                widget.onPaymentSuccess(); // Call the onPaymentSuccess callback
                Navigator.of(_scaffoldContext).pop();
                // _navigateToHomeScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToHomeScreen() {
    Navigator.of(_scaffoldContext).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  void _showPaymentFailureMessage() {
    showDialog(
      context: _scaffoldContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Failed'),
          content: Text('There was an error processing your payment. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentMethodSpecificFields() {
    return Column(
      children: [
        TextFormField(
          controller: _amountController,
          decoration: InputDecoration(
            labelText: 'Amount',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.attach_money),
            prefixText: '₹ ',
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the amount';
            }
            if (double.tryParse(value) == null || double.parse(value) <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        if (_selectedPaymentMethod == 'PhonePe' ||
            _selectedPaymentMethod == 'Google Pay')
          TextFormField(
            controller: _upiController,
            decoration: InputDecoration(
              labelText: 'UPI ID',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.account_balance_wallet),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your UPI ID';
              }
              return null;
            },
          )
        else if (_selectedPaymentMethod == 'Card')
          Column(
            children: [
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your card number';
                  }
                  if (value.length < 16) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _cardNameController,
                decoration: InputDecoration(
                  labelText: 'Name on Card',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name on the card';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cardExpiryController,
                      readOnly: true,
                      onTap: () => _selectExpiryDate(context),
                      decoration: InputDecoration(
                        labelText: 'Expiry (MM/YY)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter expiry date';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cardCVVController,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter CVV';
                        }
                        if (value.length < 3) {
                          return 'CVV must be 3 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          )
        else if (_selectedPaymentMethod == 'Bank Transfer')
          Column(
            children: [
              TextFormField(
                controller: _accNumberController,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your account number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _ifscCodeController,
                decoration: InputDecoration(
                  labelText: 'IFSC Code',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.code),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the IFSC code';
                  }
                  return null;
                },
              ),
            ],
          ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Payment Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                  ),
                  itemCount: _paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = _paymentMethods[index];
                    return Card(
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = method['name'];
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedPaymentMethod == method['name']
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(method['icon']),
                              SizedBox(width: 8),
                              Text(method['name']),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _buildPaymentMethodSpecificFields(),
                ElevatedButton(
                  onPressed: _submitPayment,
                  child: Text('Confirm Payment'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
}
