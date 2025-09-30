class CurrencyUtils {
  static const Map<String, String> _currencySymbols = {
    'USD': '\$', // Dólar Americano
    'EUR': '€',  // Euro
    'JPY': '¥',  // Iene Japonês
    'GBP': '£',  // Libra Esterlina
    'AUD': 'A\$',// Dólar Australiano
    'CAD': 'C\$',// Dólar Canadense
    'CHF': 'CHF',// Franco Suíço
    'CNY': '¥',  // Yuan Chinês
    'BRL': 'R\$',// Real Brasileiro
  };

  static String getCurrencySymbol(String currencyCode) {
    return _currencySymbols[currencyCode] ?? currencyCode;
  }
}