import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/score_data.dart';

class ScoreProvider with ChangeNotifier {
  ScoreData _scoreData = ScoreData();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSubmitted = false;

  ScoreData get scoreData => _scoreData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSubmitted => _isSubmitted;

  void updateBasicInfo({
    String? trainNumber,
    String? stationName,
    String? dateOfInspection,
    String? timeOfInspection,
    String? contractorName,
    String? supervisorName,
    String? inspectorName,
    int? numberOfCoaches,
  }) {
    if (trainNumber != null) _scoreData.trainNumber = trainNumber;
    if (stationName != null) _scoreData.stationName = stationName;
    if (dateOfInspection != null)
      _scoreData.dateOfInspection = dateOfInspection;
    if (timeOfInspection != null)
      _scoreData.timeOfInspection = timeOfInspection;
    if (contractorName != null) _scoreData.contractorName = contractorName;
    if (supervisorName != null) _scoreData.supervisorName = supervisorName;
    if (inspectorName != null) _scoreData.inspectorName = inspectorName;
    if (numberOfCoaches != null) {
      _scoreData.numberOfCoaches = numberOfCoaches;
      _initializeCoachScores(numberOfCoaches);
    }
    notifyListeners();
  }

  void _initializeCoachScores(int numberOfCoaches) {
    _scoreData.coachScores.clear();
    for (int i = 1; i <= numberOfCoaches; i++) {
      String coachId = 'C$i';
      _scoreData.coachScores[coachId] = CoachScores(coachId: coachId);

      // Initialize toilet scores
      for (int j = 1; j <= 4; j++) {
        String toiletId = 'T$j';
        _scoreData.coachScores[coachId]!.toiletScores[toiletId] =
            ToiletScore(toiletId: toiletId);
      }

      // Initialize doorway scores
      for (int j = 1; j <= 2; j++) {
        _scoreData.coachScores[coachId]!.doorwayScores['D$j'] = 0;
      }

      // Initialize vestibule scores
      for (int j = 1; j <= 2; j++) {
        _scoreData.coachScores[coachId]!.vestibuleScores['B$j'] = 0;
      }
    }
  }

  void updateToiletScore(
      String coachId, String toiletId, String scoreType, int score) {
    if (_scoreData.coachScores[coachId]?.toiletScores[toiletId] != null) {
      switch (scoreType) {
        case 'cleaning':
          _scoreData.coachScores[coachId]!.toiletScores[toiletId]!
              .cleaningScore = score;
          break;
        case 'completeness':
          _scoreData.coachScores[coachId]!.toiletScores[toiletId]!
              .completenessScore = score;
          break;
        case 'hygiene':
          _scoreData.coachScores[coachId]!.toiletScores[toiletId]!
              .hygieneScore = score;
          break;
        case 'pressure':
          _scoreData.coachScores[coachId]!.toiletScores[toiletId]!
              .pressureScore = score;
          break;
        case 'wiping':
          _scoreData.coachScores[coachId]!.toiletScores[toiletId]!.wipingScore =
              score;
          break;
        case 'doorstep':
          _scoreData.coachScores[coachId]!.toiletScores[toiletId]!
              .doorStepScore = score;
          break;
        case 'freshener':
          _scoreData.coachScores[coachId]!.toiletScores[toiletId]!
              .freshenerScore = score;
          break;
        case 'mosquito':
          _scoreData.coachScores[coachId]!.toiletScores[toiletId]!
              .mosquitoScore = score;
          break;
      }
      notifyListeners();
    }
  }

  void updateDoorwayScore(String coachId, String doorwayId, int score) {
    if (_scoreData.coachScores[coachId] != null) {
      _scoreData.coachScores[coachId]!.doorwayScores[doorwayId] = score;
      notifyListeners();
    }
  }

  void updateVestibuleScore(String coachId, String vestibuleId, int score) {
    if (_scoreData.coachScores[coachId] != null) {
      _scoreData.coachScores[coachId]!.vestibuleScores[vestibuleId] = score;
      notifyListeners();
    }
  }

  void updatePlatformReturnScore(String activityId, int score) {
    _scoreData.platformReturnScores[activityId] = score;
    notifyListeners();
  }

  void updatePlatformReturnRemarks(String activityId, String remarks) {
    _scoreData.platformReturnRemarks[activityId] = remarks;
    notifyListeners();
  }

  void initializeDefaultData() {
    // Initialize Platform Return Activities
    _scoreData.platformReturnScores = {
      'cleaning_wiping_toilet': 0,
      'interior_cleaning': 0,
      'cleaning_wiping_required': 0,
      'floor_including_area': 0,
      'disposal_garbage': 0,
    };

    // Initialize Payment Activities
    _scoreData.paymentActivities = {
      'P101': PaymentActivity(
          description:
              'Interior cleaning of coaches including Door and side frames (complete cleaning of coach interior as per SOP)'),
      'P102': PaymentActivity(
          description:
              'Penalty of Rs 500/ per machine going shall be imposed for not working equipment bearing devices in any machine breakdown'),
      'P103': PaymentActivity(
          description:
              'Penalty of Rs 500/ per instance going shall be imposed for not removing defiant to lift or event of any passenger complaint'),
      'P104': PaymentActivity(
          description:
              'Penalty of Rs 500/ per instance going shall be imposed for not reporting before the time of arrival at station'),
      'P105': PaymentActivity(
          description:
              'Penalty of Rs 500/ per instance going shall be imposed for not completion required in compliance as the target given and/or in condition event'),
      'P106': PaymentActivity(
          description:
              'Penalty of Rs 500/ per instance if bearing of water stations below at above of five working hours'),
      'P107': PaymentActivity(
          description:
              'Penalty of Rs 500/ per instance going shall be imposed for not toilet floor complaint showing cleaning activity'),
      'P108': PaymentActivity(
          description:
              'Penalty of Rs 500/ per instance going shall be imposed for not All room shall be imposed for bearing door only disposal'),
      'P109': PaymentActivity(
          description:
              'Penalty of Rs 500/ per instance going shall be imposed for not system shall be imposed for not working process of any given time'),
      'P110': PaymentActivity(
          description:
              'Penalty of Rs 500/ per instance going shall be imposed for not the state employment of said or received/external destruction shall be or and shall be imposed for not development state'),
      'P111': PaymentActivity(
          description:
              'Penalty of Rs 500/ per instance going shall be imposed for not complete disposal of all equipment damage'),
      'P112': PaymentActivity(
          description:
              'Penalty of Rs 500/ per room & equipment/ WC any shall be imposed for not employing/not of all equipment/WC at per monitor'),
      'P113': PaymentActivity(
          description:
              'Penalty of Rs 500/ per instance for not maintaining with the dampness at each Railway station'),
    };

    // Initialize Tools and Equipment
    _scoreData.toolsEquipment = {
      'spray_bottle': ToolEquipment(
          name:
              'Spray Bottle (@ 2 per work station to be replaced in 2 months (For two shift) (1*2+2))',
          unit: 'Nos',
          quantityPerMonth: 11),
      'brush_door': ToolEquipment(
          name:
              'Brush for door area/ (only steel brush) with wooden handle Length 25cms x width 5.5cms (@ 2 per work station per month one for two shift) - (2x1))',
          unit: 'Nos',
          quantityPerMonth: 22),
      'brush_toilet': ToolEquipment(
          name:
              'Brush for toilet cleaning(20 cm long wooden(plastic) handle with nix type of brush(plastic & steel)(@ 2 per work station per month for two shift) - (2x1))',
          unit: 'Nos',
          quantityPerMonth: 22),
      'broom_coconut': ToolEquipment(
          name:
              'Broom coconut/Plastic (@ per workstation per month for two shift)-(2x1))',
          unit: 'Nos',
          quantityPerMonth: 22),
      'bucket': ToolEquipment(
          name:
              'Bucket(Cap 5 (10 lit capacity) for cleaning solution for mopping (@ 2 per work station per six months for two shift)-(2x1))',
          unit: 'Nos',
          quantityPerMonth: 3),
    };

    // Initialize Chemicals
    _scoreData.chemicals = {
      'pvc_degreasing': Chemical(
          name: 'PVC Degreasing solution',
          approvedBrand:
              'Spiral (Johnson Diversey)/ or Jaqtin Neutral or Eco Lab or Chela brand or APC I Floyatle',
          quantityStockPer2Months: 50),
      'ceramic_stainless': Chemical(
          name: 'Ceramic & Stainless steel toilet fitting cleaning agent',
          approvedBrand:
              'Tanks (K)/ Taski R6 (Johnson Diversey)/Spiral HCI or Jaqtin Neutral or Eco Lab or Chela & Shaker & Floyatle',
          quantityStockPer2Months: 50),
      'glass_cleaning': Chemical(
          name: 'Glass cleaning agent (for toilet & wash basin)',
          approvedBrand:
              'Taski R1 (Johnson Diversey) or DC glass cleaner or Eco Lab or Chela or Shaker & Floyatle',
          quantityStockPer2Months: 20),
      'disinfectant': Chemical(
          name: 'Disinfectant',
          approvedBrand:
              'PHALD HI (Johnson Diversey) or Arrabtech or Ecotab or Eco Lab',
          quantityStockPer2Months: 10),
      'air_freshener': Chemical(
          name: 'Air Freshener',
          approvedBrand:
              'Preferably market based Taski R5 or equivalent, Ecotab or Eco Lab or Chela or Floyatle or Glyphate on any other brand approved by approval branch',
          quantityStockPer2Months: 10),
    };

    // Initialize Staff Members
    _scoreData.staffMembers = {
      'gun_boat': StaffMember(
          name: 'Gun boat @ (one/staff/year', unit: 'pair', quantity: 5),
      'overall_suit': StaffMember(
          name: 'Overall suit (one @ uniform/year)', unit: 'Nos', quantity: 5),
      'cap': StaffMember(
          name: 'Cap @ 1 nos / person/ year', unit: 'Nos', quantity: 5),
      'hand_gloves': StaffMember(
          name: 'Hand @ 1 nos person/ year', unit: 'pair', quantity: 5),
      'goggle': StaffMember(
          name: 'Goggle @ 1 no/person/ year', unit: 'Nos', quantity: 5),
      'inspection_bag': StaffMember(
          name: 'Inspection bag plus one / Person/ year',
          unit: 'Nos',
          quantity: 5),
      'torch': StaffMember(name: 'Torch', unit: 'Nos', quantity: 5),
      'cotton_waste': StaffMember(
          name: 'Cotton waste as per roll/per month',
          unit: 'Nos',
          quantity: 30),
      'lemon_soap': StaffMember(
          name: 'Lemon orange sabun-one/staff/month',
          unit: 'Nos',
          quantity: 30),
    };

    notifyListeners();
  }

  void calculateOverallScore() {
    int totalScore = 0;
    int maxScore = 0;

    // Calculate coach scores
    for (var coachScore in _scoreData.coachScores.values) {
      for (var toiletScore in coachScore.toiletScores.values) {
        totalScore += (toiletScore.cleaningScore ?? 0) +
            (toiletScore.completenessScore ?? 0) +
            (toiletScore.hygieneScore ?? 0) +
            (toiletScore.pressureScore ?? 0) +
            (toiletScore.wipingScore ?? 0) +
            (toiletScore.doorStepScore ?? 0) +
            (toiletScore.freshenerScore ?? 0) +
            (toiletScore.mosquitoScore ?? 0);
        maxScore += 80; // 8 parameters × 10 max score
      }

      for (var doorwayScore in coachScore.doorwayScores.values) {
        totalScore += doorwayScore;
        maxScore += 10;
      }

      for (var vestibuleScore in coachScore.vestibuleScores.values) {
        totalScore += vestibuleScore;
        maxScore += 10;
      }
    }

    // Calculate platform return scores
    for (var score in _scoreData.platformReturnScores.values) {
      totalScore += score;
      maxScore += 10;
    }

    _scoreData.totalScoreObtained = totalScore;
    _scoreData.maximumMarks = maxScore;
    _scoreData.percentage = maxScore > 0 ? (totalScore / maxScore) * 100 : 0;

    notifyListeners();
  }

  bool validateForm() {
    if (_scoreData.trainNumber == null || _scoreData.trainNumber!.isEmpty) {
      _errorMessage = 'Train number is required';
      return false;
    }
    if (_scoreData.stationName == null || _scoreData.stationName!.isEmpty) {
      _errorMessage = 'Station name is required';
      return false;
    }
    if (_scoreData.dateOfInspection == null ||
        _scoreData.dateOfInspection!.isEmpty) {
      _errorMessage = 'Date of inspection is required';
      return false;
    }
    if (_scoreData.numberOfCoaches == null ||
        _scoreData.numberOfCoaches! <= 0) {
      _errorMessage =
          'Number of coaches is required and must be greater than 0';
      return false;
    }

    _errorMessage = null;
    return true;
  }

  Future<bool> submitForm() async {
    if (!validateForm()) {
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      calculateOverallScore();

      final response = await http.post(
        Uri.parse('https://webhook.site/8e5b94df-a18d-49fc-ad2c-6980d5b53c5c'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_scoreData.toJson()),
      );

      if (response.statusCode == 200) {
        _isSubmitted = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to submit form. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage =
          'Network error. Please check your connection and try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void resetForm() {
    _scoreData = ScoreData();
    _isSubmitted = false;
    _errorMessage = null;
    initializeDefaultData();
    notifyListeners();
  }

  void saveFormData() {
    // Auto-save functionality - in a real app, this would save to local storage
    // For now, we'll just calculate and update the total score
    calculateOverallScore();
  }
}
