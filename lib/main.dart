import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart' as mysql;

class HospitalInputPage extends StatefulWidget {
  @override
  _HospitalInputPageState createState() => _HospitalInputPageState();
}

class _HospitalInputPageState extends State<HospitalInputPage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _foundedDateController = TextEditingController();
  final TextEditingController _accreditationController = TextEditingController();
  final TextEditingController _numBedsController = TextEditingController();
  final TextEditingController _numStaffController = TextEditingController();
  Future<void> saveToDatabase() async {
    final settings = mysql.ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      db: 'ol',
    );

    final connection = await mysql.MySqlConnection.connect(settings);

    try {
      await connection.query(
        'INSERT INTO hospital_registration (name, address, email, phone, description, website, founded_date, accreditation, num_beds, num_staff) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [_nameController.text, _addressController.text, _emailController.text, _phoneNumberController.text, _descriptionController.text, _websiteController.text, _foundedDateController.text, _accreditationController.text, _numBedsController.text, _numStaffController.text],
      );
    } catch (e) {
      print('Error inserting data: $e');
    } finally {
      await connection.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text("Hospital Registeration Request",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600
            ),),
            SizedBox(height: 20),
            _buildInputField(_nameController, 'Hospital Name'),
            SizedBox(height: 16),
            _buildInputField(_addressController, 'Address'),
            SizedBox(height: 16),
            _buildInputField(_emailController, 'Email'),
            SizedBox(height: 16),
            _buildInputField(_phoneNumberController, 'Phone Number'),
            SizedBox(height: 16),
            _buildInputField(_descriptionController, 'Description'),
            SizedBox(height: 16),
            _buildInputField(_websiteController, 'Website'),
            SizedBox(height: 16),
            Container(
              width: 321,
              height: 30,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: TextField(
                            controller: _foundedDateController,
                            cursorColor: Color(0xFF6B62FE),
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              hintText: "Found Date",
                              hintStyle: TextStyle(
                                color: Color(0xFFA8A8A8),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: -10, bottom: 6, left: 12), // Adjust padding to align text with label
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: Color(0xFF6C63FF),
                                  // Change this to your desired color
                                  colorScheme: ColorScheme.light(
                                      primary: Color(0xFF6C63FF)),
                                  // Change this to your desired color
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary),
                                ),
                                child: child!,
                              );
                            });

                          if (pickedDate != null) {
                            _foundedDateController.text = pickedDate.toString().split(' ')[0]; // Extract date portion only
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(
                            Icons.calendar_today,
                            color: Color(0xFFA8A8A8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            _buildInputField(_accreditationController, 'Accreditation Status'),
            SizedBox(height: 16),
            _buildInputField(_numBedsController, 'Number of Beds', keyboardType: TextInputType.number),
            SizedBox(height: 16),
            _buildInputField(_numStaffController, 'Number of Staff', keyboardType: TextInputType.number),
            SizedBox(height: 24),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF6C63FF)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.zero,
            ),
            elevation: MaterialStateProperty.all<double>(0),
          ),
          onPressed: saveToDatabase,
          child: SizedBox(
            height: 20,
            width: 200,
            child: Center(
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hintText, {TextInputType? keyboardType}) {
    return Container(
      width: 321,
      height: 30,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50, color: Color(0xFFD9D9D9)),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      child: Stack(
        children: [
          // Positioned(
          //   left: 12,
          //   top: 6,
          //   child: Text(
          //     hintText,
          //     style: TextStyle(
          //       color: Color(0xFFA8A8A8),
          //       fontSize: 14,
          //       fontFamily: 'Inter',
          //       fontWeight: FontWeight.w400,
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              cursorColor: Color(0xFF6B62FE),
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Color(0xFFA8A8A8),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.only(top: -10, bottom: 6, left: 12), // Adjust padding to align text with label
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    _foundedDateController.dispose();
    _accreditationController.dispose();
    _numBedsController.dispose();
    _numStaffController.dispose();
    super.dispose();
  }
}

void main() => runApp(MaterialApp(home: HospitalInputPage()));
