import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dukascango/domain/models/country_model.dart';
import 'package:dukascango/presentation/components/text_custom.dart';

class PhoneNumberField extends StatefulWidget {
  final Function(String fullPhoneNumber, Map<String, dynamic> countryData)
      onChanged;

  const PhoneNumberField({Key? key, required this.onChanged}) : super(key: key);

  @override
  _PhoneNumberFieldState createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  List<Country> _countries = [];
  Country? _selectedCountry;
  County? _selectedCounty;
  SubCounty? _selectedSubCounty;
  String? _selectedWard;
  bool _showGeoFields = false;

  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _phoneController.addListener(_onPhoneChanged);
  }

  Future<void> _loadCountries() async {
    final String response =
        await rootBundle.loadString('assets/json/country_data.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _countries = data.map((json) => Country.fromJson(json)).toList();
      _selectedCountry =
          _countries.firstWhere((c) => c.code == 'KE', orElse: () => _countries.first);
    });
  }

  void _onPhoneChanged() {
    setState(() {
      _showGeoFields = _phoneController.text.isNotEmpty &&
          _selectedCountry != null &&
          _selectedCountry!.counties.isNotEmpty;
    });

    if (_selectedCountry != null) {
      final String fullPhoneNumber =
          '+${_selectedCountry!.dialingCode}${_phoneController.text}';
      final Map<String, dynamic> countryData = {
        "country": _selectedCountry!.label,
        "countryCode": _selectedCountry!.code,
        "dialingCode": "+${_selectedCountry!.dialingCode}",
        "phoneNumber": fullPhoneNumber,
        "flag": _selectedCountry!.flag,
        "currency": _selectedCountry!.currency.toJson(),
        "geo": {
          "county": _selectedCounty?.label,
          "subCounty": _selectedSubCounty?.label,
          "ward": _selectedWard,
        }
      };
      widget.onChanged(fullPhoneNumber, countryData);
    }
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextCustom(text: 'Phone Number'),
        const SizedBox(height: 5.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(width: .5, color: Colors.grey),
          ),
          child: Row(
            children: [
              _buildCountryPicker(),
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.getFont('Roboto', fontSize: 18),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 15.0),
                    hintText: 'Enter phone number',
                    hintStyle: GoogleFonts.getFont('Roboto', color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showGeoFields) ..._buildGeoFields(),
      ],
    );
  }

  Widget _buildCountryPicker() {
    return GestureDetector(
      onTap: () => _showCountryPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            if (_selectedCountry != null) ...[
              Text(_selectedCountry!.flag, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 4),
              Text('+${_selectedCountry!.dialingCode}',
                  style: GoogleFonts.getFont('Roboto', fontSize: 18)),
            ],
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String searchQuery = "";
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filteredCountries = _countries
                .where((c) => c.label
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
                .toList();

            return Dialog(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search Country',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = filteredCountries[index];
                        return ListTile(
                          leading: Text(country.flag,
                              style: const TextStyle(fontSize: 24)),
                          title: Text(country.label),
                          trailing: Text('+${country.dialingCode}'),
                          onTap: () {
                            setState(() {
                              _selectedCountry = country;
                              _selectedCounty = null;
                              _selectedSubCounty = null;
                              _selectedWard = null;
                              _onPhoneChanged();
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildGeoFields() {
    if (_selectedCountry == null || _selectedCountry!.counties.isEmpty) {
      return [];
    }

    return [
      const SizedBox(height: 15.0),
      _buildSearchableDropdown(
        hintText: 'Select County',
        selectedValue: _selectedCounty?.label,
        items: _selectedCountry!.counties.map((c) => c.label).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCounty = _selectedCountry!.counties.firstWhere((c) => c.label == value);
            _selectedSubCounty = null;
            _selectedWard = null;
            _onPhoneChanged();
          });
        },
      ),
      if (_selectedCounty != null && _selectedCounty!.subCounties.isNotEmpty) ...[
        const SizedBox(height: 15.0),
        _buildSearchableDropdown(
          hintText: 'Select Sub-County',
          selectedValue: _selectedSubCounty?.label,
          items: _selectedCounty!.subCounties.map((sc) => sc.label).toList(),
          onChanged: (value) {
            setState(() {
              _selectedSubCounty = _selectedCounty!.subCounties.firstWhere((sc) => sc.label == value);
              _selectedWard = null;
              _onPhoneChanged();
            });
          },
        ),
      ],
      if (_selectedSubCounty != null && _selectedSubCounty!.wards.isNotEmpty) ...[
        const SizedBox(height: 15.0),
        _buildSearchableDropdown(
          hintText: 'Select Ward',
          selectedValue: _selectedWard,
          items: _selectedSubCounty!.wards,
          onChanged: (value) {
            setState(() {
              _selectedWard = value;
              _onPhoneChanged();
            });
          },
        ),
      ],
    ];
  }

  Widget _buildSearchableDropdown({
    required String hintText,
    required String? selectedValue,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            String searchQuery = "";
            return StatefulBuilder(
              builder: (context, setDialogState) {
                final filteredItems = items
                    .where((item) => item.toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList();

                return Dialog(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            prefixIcon: const Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            setDialogState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            return ListTile(
                              title: Text(item),
                              onTap: () {
                                onChanged(item);
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(width: .5, color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedValue ?? hintText,
              style: GoogleFonts.getFont('Roboto',
                  color: selectedValue != null ? Colors.black : Colors.grey,
                  fontSize: 18),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
