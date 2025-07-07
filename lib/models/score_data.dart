class ScoreData {
  String? trainNumber;
  String? stationName;
  String? dateOfInspection;
  String? timeOfInspection;
  String? contractorName;
  String? supervisorName;
  String? inspectorName;
  int? numberOfCoaches;
  int? totalScoreObtained;
  int? maximumMarks;
  double? percentage;

  // Clean Train Station Activities
  Map<String, CoachScores> coachScores = {};

  // Platform Return Activities
  Map<String, int> platformReturnScores = {};
  Map<String, String> platformReturnRemarks = {};

  // Payment Schedule Activities
  Map<String, PaymentActivity> paymentActivities = {};

  // Tools and Equipment
  Map<String, ToolEquipment> toolsEquipment = {};

  // Chemicals
  Map<String, Chemical> chemicals = {};

  // Staff Details
  Map<String, StaffMember> staffMembers = {};

  ScoreData();

  Map<String, dynamic> toJson() {
    return {
      'trainNumber': trainNumber,
      'stationName': stationName,
      'dateOfInspection': dateOfInspection,
      'timeOfInspection': timeOfInspection,
      'contractorName': contractorName,
      'supervisorName': supervisorName,
      'inspectorName': inspectorName,
      'numberOfCoaches': numberOfCoaches,
      'totalScoreObtained': totalScoreObtained,
      'maximumMarks': maximumMarks,
      'percentage': percentage,
      'coachScores': coachScores.map((k, v) => MapEntry(k, v.toJson())),
      'platformReturnScores': platformReturnScores,
      'platformReturnRemarks': platformReturnRemarks,
      'paymentActivities':
          paymentActivities.map((k, v) => MapEntry(k, v.toJson())),
      'toolsEquipment': toolsEquipment.map((k, v) => MapEntry(k, v.toJson())),
      'chemicals': chemicals.map((k, v) => MapEntry(k, v.toJson())),
      'staffMembers': staffMembers.map((k, v) => MapEntry(k, v.toJson())),
    };
  }
}

class CoachScores {
  String coachId;
  Map<String, ToiletScore> toiletScores = {};
  Map<String, int> doorwayScores = {};
  Map<String, int> vestibuleScores = {};

  CoachScores({required this.coachId});

  Map<String, dynamic> toJson() {
    return {
      'coachId': coachId,
      'toiletScores': toiletScores.map((k, v) => MapEntry(k, v.toJson())),
      'doorwayScores': doorwayScores,
      'vestibuleScores': vestibuleScores,
    };
  }
}

class ToiletScore {
  String toiletId;
  int? cleaningScore;
  int? completenessScore;
  int? hygieneScore;
  int? pressureScore;
  int? wipingScore;
  int? doorStepScore;
  int? freshenerScore;
  int? mosquitoScore;
  String? remarks;

  ToiletScore({required this.toiletId});

  Map<String, dynamic> toJson() {
    return {
      'toiletId': toiletId,
      'cleaningScore': cleaningScore,
      'completenessScore': completenessScore,
      'hygieneScore': hygieneScore,
      'pressureScore': pressureScore,
      'wipingScore': wipingScore,
      'doorStepScore': doorStepScore,
      'freshenerScore': freshenerScore,
      'mosquitoScore': mosquitoScore,
      'remarks': remarks,
    };
  }
}

class PaymentActivity {
  String description;
  int? score;
  String? remarks;

  PaymentActivity({required this.description, this.score, this.remarks});

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'score': score,
      'remarks': remarks,
    };
  }
}

class ToolEquipment {
  String name;
  String unit;
  int? quantityPerMonth;
  String? remarks;

  ToolEquipment(
      {required this.name,
      required this.unit,
      this.quantityPerMonth,
      this.remarks});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unit': unit,
      'quantityPerMonth': quantityPerMonth,
      'remarks': remarks,
    };
  }
}

class Chemical {
  String name;
  String approvedBrand;
  int? quantityStockPer2Months;
  String? remarks;

  Chemical(
      {required this.name,
      required this.approvedBrand,
      this.quantityStockPer2Months,
      this.remarks});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'approvedBrand': approvedBrand,
      'quantityStockPer2Months': quantityStockPer2Months,
      'remarks': remarks,
    };
  }
}

class StaffMember {
  String name;
  String unit;
  int? quantity;
  String? remarks;

  StaffMember(
      {required this.name, required this.unit, this.quantity, this.remarks});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unit': unit,
      'quantity': quantity,
      'remarks': remarks,
    };
  }
}
