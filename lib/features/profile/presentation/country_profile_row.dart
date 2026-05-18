import 'package:flutter/material.dart';

import '../model/country_option.dart';

class CountryProfileRow extends StatelessWidget {
  const CountryProfileRow({required this.countryCode, super.key});

  final String? countryCode;

  @override
  Widget build(BuildContext context) {
    final country = findCountryByCode(countryCode);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Country',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            country == null ? '-' : '${country.flag} ${country.name}',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
