/// Конвертация денежных сумм между доменом (рубли) и БД (копейки).
int moneyToMinor(double amount) => (amount * 100).round();

double moneyFromMinor(int minor) => minor / 100;

int? moneyToMinorNullable(double? amount) =>
    amount == null ? null : moneyToMinor(amount);

double? moneyFromMinorNullable(int? minor) =>
    minor == null ? null : moneyFromMinor(minor);
