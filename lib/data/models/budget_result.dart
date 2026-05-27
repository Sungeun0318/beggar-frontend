class BudgetResult {
  final int minBudgetPerPerson;
  final int memberCount;
  final int totalBudget;

  const BudgetResult({
    required this.minBudgetPerPerson,
    required this.memberCount,
    required this.totalBudget,
  });

  factory BudgetResult.fromJson(Map<String, dynamic> json) => BudgetResult(
        minBudgetPerPerson: json['minBudgetPerPerson'] as int,
        memberCount: json['memberCount'] as int,
        totalBudget: json['totalBudget'] as int,
      );

  Map<String, dynamic> toJson() => {
        'minBudgetPerPerson': minBudgetPerPerson,
        'memberCount': memberCount,
        'totalBudget': totalBudget,
      };
}
