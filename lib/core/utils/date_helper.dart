
class DateHelper {
  const DateHelper();

  String getWeekday(String date) {
    final dt = DateTime.parse(date);
    const weekdays = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche'
    ];
    return weekdays[dt.weekday - 1];
  }
}
