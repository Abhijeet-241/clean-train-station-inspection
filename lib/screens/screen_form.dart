import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/score_provider.dart';
import '../widgets/score_input_tile.dart';
import '../models/score_data.dart';

class ScoreFormScreen extends StatefulWidget {
  @override
  _ScoreFormScreenState createState() => _ScoreFormScreenState();
}

class _ScoreFormScreenState extends State<ScoreFormScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScoreProvider>(context, listen: false)
          .initializeDefaultData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clean Train Station Inspection'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Basic Info'),
            Tab(text: 'Coach Scores'),
            Tab(text: 'Platform Return'),
            Tab(text: 'Payment Activities'),
            Tab(text: 'Resources'),
            Tab(text: 'Summary'),
          ],
        ),
      ),
      body: Consumer<ScoreProvider>(
        builder: (context, scoreProvider, child) {
          if (scoreProvider.isSubmitted) {
            return _buildSuccessScreen(scoreProvider);
          }

          return Form(
            key: _formKey,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBasicInfoTab(scoreProvider),
                _buildCoachScoresTab(scoreProvider),
                _buildPlatformReturnTab(scoreProvider),
                _buildPaymentActivitiesTab(scoreProvider),
                _buildResourcesTab(scoreProvider),
                _buildSummaryTab(scoreProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuccessScreen(ScoreProvider scoreProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 100,
            color: Colors.green,
          ),
          SizedBox(height: 24),
          Text(
            'Form Submitted Successfully!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 16),
          Text(
            'Your inspection data has been recorded.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              scoreProvider.resetForm();
              _tabController.animateTo(0);
            },
            child: Text('Start New Inspection'),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoTab(ScoreProvider scoreProvider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Basic Information',
            subtitle: 'Enter the basic details of the inspection',
          ),
          FormTextField(
            label: 'Train Number',
            initialValue: scoreProvider.scoreData.trainNumber,
            onChanged: (value) =>
                scoreProvider.updateBasicInfo(trainNumber: value),
            isRequired: true,
            hint: 'e.g., 12309',
          ),
          FormTextField(
            label: 'Station Name',
            initialValue: scoreProvider.scoreData.stationName,
            onChanged: (value) =>
                scoreProvider.updateBasicInfo(stationName: value),
            isRequired: true,
            hint: 'e.g., New Delhi Junction',
          ),
          FormTextField(
            label: 'Date of Inspection',
            initialValue: scoreProvider.scoreData.dateOfInspection,
            onChanged: (value) =>
                scoreProvider.updateBasicInfo(dateOfInspection: value),
            isRequired: true,
            hint: 'DD/MM/YYYY',
          ),
          FormTextField(
            label: 'Time of Inspection',
            initialValue: scoreProvider.scoreData.timeOfInspection,
            onChanged: (value) =>
                scoreProvider.updateBasicInfo(timeOfInspection: value),
            hint: 'HH:MM',
          ),
          FormTextField(
            label: 'Contractor Name',
            initialValue: scoreProvider.scoreData.contractorName,
            onChanged: (value) =>
                scoreProvider.updateBasicInfo(contractorName: value),
          ),
          FormTextField(
            label: 'Supervisor Name',
            initialValue: scoreProvider.scoreData.supervisorName,
            onChanged: (value) =>
                scoreProvider.updateBasicInfo(supervisorName: value),
          ),
          FormTextField(
            label: 'Inspector Name',
            initialValue: scoreProvider.scoreData.inspectorName,
            onChanged: (value) =>
                scoreProvider.updateBasicInfo(inspectorName: value),
          ),
          FormTextField(
            label: 'Number of Coaches',
            initialValue: scoreProvider.scoreData.numberOfCoaches?.toString(),
            onChanged: (value) => scoreProvider.updateBasicInfo(
              numberOfCoaches: int.tryParse(value) ?? 0,
            ),
            keyboardType: TextInputType.number,
            isRequired: true,
            hint: 'e.g., 13',
          ),
          if (scoreProvider.errorMessage != null)
            Container(
              margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[300]!),
              ),
              child: Text(
                scoreProvider.errorMessage!,
                style: TextStyle(color: Colors.red[800]),
              ),
            ),
          SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (scoreProvider.scoreData.numberOfCoaches != null &&
                    scoreProvider.scoreData.numberOfCoaches! > 0) {
                  _tabController.animateTo(1);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Please enter the number of coaches first')),
                  );
                }
              },
              child: Text('Continue to Coach Scores'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachScoresTab(ScoreProvider scoreProvider) {
    if (scoreProvider.scoreData.numberOfCoaches == null ||
        scoreProvider.scoreData.numberOfCoaches! <= 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Please enter the number of coaches first',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _tabController.animateTo(0),
              child: Text('Go to Basic Info'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Coach Scores',
            subtitle: 'Score each coach component (Scale: 0-10)',
          ),
          ...List.generate(
            scoreProvider.scoreData.numberOfCoaches!,
            (index) => _buildCoachScoreSection(
              scoreProvider,
              'C${index + 1}',
            ),
          ),
          SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _tabController.animateTo(0),
                  child: Text('Previous'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _tabController.animateTo(2),
                  child: Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoachScoreSection(ScoreProvider scoreProvider, String coachId) {
    final coachData = scoreProvider.scoreData.coachScores[coachId];
    if (coachData == null) return SizedBox.shrink();

    return CoachSection(
      coachId: coachId,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toilet Scores
          Text(
            'Toilet Scores',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
          ),
          SizedBox(height: 12),
          ...List.generate(4, (toiletIndex) {
            String toiletId = 'T${toiletIndex + 1}';
            return ExpansionTile(
              title: Text('Toilet $toiletId'),
              children: [
                ScoreInputTile(
                  title: 'Toilet cleaning',
                  currentScore: coachData.toiletScores[toiletId]?.cleaningScore,
                  onScoreChanged: (score) => scoreProvider.updateToiletScore(
                    coachId,
                    toiletId,
                    'cleaning',
                    score,
                  ),
                ),
                ScoreInputTile(
                  title: 'Completeness',
                  currentScore:
                      coachData.toiletScores[toiletId]?.completenessScore,
                  onScoreChanged: (score) => scoreProvider.updateToiletScore(
                    coachId,
                    toiletId,
                    'completeness',
                    score,
                  ),
                ),
                ScoreInputTile(
                  title: 'Hygiene',
                  currentScore: coachData.toiletScores[toiletId]?.hygieneScore,
                  onScoreChanged: (score) => scoreProvider.updateToiletScore(
                    coachId,
                    toiletId,
                    'hygiene',
                    score,
                  ),
                ),
                ScoreInputTile(
                  title: 'Pressure',
                  currentScore: coachData.toiletScores[toiletId]?.pressureScore,
                  onScoreChanged: (score) => scoreProvider.updateToiletScore(
                    coachId,
                    toiletId,
                    'pressure',
                    score,
                  ),
                ),
                ScoreInputTile(
                  title: 'Wiping of wash basin',
                  currentScore: coachData.toiletScores[toiletId]?.wipingScore,
                  onScoreChanged: (score) => scoreProvider.updateToiletScore(
                    coachId,
                    toiletId,
                    'wiping',
                    score,
                  ),
                ),
                ScoreInputTile(
                  title: 'Door step cleaning',
                  currentScore: coachData.toiletScores[toiletId]?.doorStepScore,
                  onScoreChanged: (score) => scoreProvider.updateToiletScore(
                    coachId,
                    toiletId,
                    'doorstep',
                    score,
                  ),
                ),
                ScoreInputTile(
                  title: 'Freshener & Air',
                  currentScore:
                      coachData.toiletScores[toiletId]?.freshenerScore,
                  onScoreChanged: (score) => scoreProvider.updateToiletScore(
                    coachId,
                    toiletId,
                    'freshener',
                    score,
                  ),
                ),
                ScoreInputTile(
                  title: 'Mosquito Repellent',
                  currentScore: coachData.toiletScores[toiletId]?.mosquitoScore,
                  onScoreChanged: (score) => scoreProvider.updateToiletScore(
                    coachId,
                    toiletId,
                    'mosquito',
                    score,
                  ),
                ),
              ],
            );
          }),

          SizedBox(height: 24),

          // Doorway Scores
          Text(
            'Doorway Areas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
          ),
          SizedBox(height: 12),
          ...List.generate(2, (doorIndex) {
            String doorId = 'D${doorIndex + 1}';
            return ScoreInputTile(
              title: 'Doorway $doorId',
              currentScore: coachData.doorwayScores[doorId],
              onScoreChanged: (score) => scoreProvider.updateDoorwayScore(
                coachId,
                doorId,
                score,
              ),
            );
          }),

          SizedBox(height: 24),

          // Vestibule Scores
          Text(
            'Vestibule Areas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
          ),
          SizedBox(height: 12),
          ...List.generate(2, (vestibuleIndex) {
            String vestibuleId = 'B${vestibuleIndex + 1}';
            return ScoreInputTile(
              title: 'Vestibule $vestibuleId',
              currentScore: coachData.vestibuleScores[vestibuleId],
              onScoreChanged: (score) => scoreProvider.updateVestibuleScore(
                coachId,
                vestibuleId,
                score,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPlatformReturnTab(ScoreProvider scoreProvider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Platform Return Activities',
            subtitle: 'Score platform return train activities',
          ),
          ScoreInputTile(
            title: 'Cleaning and wiping of toilet area',
            subtitle:
                'And fittings including washbasin, mirrors, Cleaning of floor, walls and ceiling',
            currentScore: scoreProvider
                .scoreData.platformReturnScores['cleaning_wiping_toilet'],
            onScoreChanged: (score) => scoreProvider.updatePlatformReturnScore(
                'cleaning_wiping_toilet', score),
          ),
          ScoreInputTile(
            title: 'Interior Cleaning of compartments',
            subtitle: 'doorways, gangways, vestibules etc',
            currentScore: scoreProvider
                .scoreData.platformReturnScores['interior_cleaning'],
            onScoreChanged: (score) => scoreProvider.updatePlatformReturnScore(
                'interior_cleaning', score),
          ),
          ScoreInputTile(
            title: 'Cleaning & wiping if required',
            subtitle: 'of all berths/ panels, luggage racks & windows',
            currentScore: scoreProvider
                .scoreData.platformReturnScores['cleaning_wiping_required'],
            onScoreChanged: (score) => scoreProvider.updatePlatformReturnScore(
                'cleaning_wiping_required', score),
          ),
          ScoreInputTile(
            title: 'Floor including area under the seats/berths',
            subtitle: 'on & wiping if required',
            currentScore: scoreProvider
                .scoreData.platformReturnScores['floor_including_area'],
            onScoreChanged: (score) => scoreProvider.updatePlatformReturnScore(
                'floor_including_area', score),
          ),
          ScoreInputTile(
            title: 'Disposal of garbage',
            currentScore: scoreProvider
                .scoreData.platformReturnScores['disposal_garbage'],
            onScoreChanged: (score) => scoreProvider.updatePlatformReturnScore(
                'disposal_garbage', score),
          ),
          SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _tabController.animateTo(1),
                  child: Text('Previous'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _tabController.animateTo(3),
                  child: Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentActivitiesTab(ScoreProvider scoreProvider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Payment Schedule Activities',
            subtitle: 'Review payment activities and penalties',
          ),
          ...scoreProvider.scoreData.paymentActivities.entries.map((entry) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      entry.value.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Remarks',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        entry.value.remarks = value;
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _tabController.animateTo(2),
                  child: Text('Previous'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _tabController.animateTo(4),
                  child: Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesTab(ScoreProvider scoreProvider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Resources',
            subtitle: 'Chemicals, Tools & Equipment, Staff Details',
          ),

          // Chemicals Section
          Text(
            'Chemicals',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
          ),
          SizedBox(height: 12),
          ...scoreProvider.scoreData.chemicals.entries.map((entry) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.value.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Approved Brand: ${entry.value.approvedBrand}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue:
                                entry.value.quantityStockPer2Months?.toString(),
                            decoration: InputDecoration(
                              labelText: 'Qty/Stock (2 months)',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              entry.value.quantityStockPer2Months =
                                  int.tryParse(value);
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: entry.value.remarks,
                            decoration: InputDecoration(
                              labelText: 'Remarks',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onChanged: (value) {
                              entry.value.remarks = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          SizedBox(height: 24),

          // Tools and Equipment Section
          Text(
            'Tools and Equipment',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
          ),
          SizedBox(height: 12),
          ...scoreProvider.scoreData.toolsEquipment.entries.map((entry) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.value.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Unit: ${entry.value.unit}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue:
                                entry.value.quantityPerMonth?.toString(),
                            decoration: InputDecoration(
                              labelText: 'Qty/Month',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              entry.value.quantityPerMonth =
                                  int.tryParse(value);
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: entry.value.remarks,
                            decoration: InputDecoration(
                              labelText: 'Remarks',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onChanged: (value) {
                              entry.value.remarks = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          SizedBox(height: 24),

          // Staff Details Section
          Text(
            'Staff Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
          ),
          SizedBox(height: 12),
          ...scoreProvider.scoreData.staffMembers.entries.map((entry) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.value.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Unit: ${entry.value.unit}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: entry.value.quantity?.toString(),
                            decoration: InputDecoration(
                              labelText: 'Quantity',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              entry.value.quantity = int.tryParse(value);
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: entry.value.remarks,
                            decoration: InputDecoration(
                              labelText: 'Remarks',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onChanged: (value) {
                              entry.value.remarks = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _tabController.animateTo(3),
                  child: Text('Previous'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _tabController.animateTo(5),
                  child: Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTab(ScoreProvider scoreProvider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Inspection Summary',
            subtitle: 'Review your inspection data before submitting',
          ),

          // Basic Information Summary
          Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Basic Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                  ),
                  SizedBox(height: 12),
                  _buildSummaryRow('Train Number',
                      scoreProvider.scoreData.trainNumber ?? 'Not provided'),
                  _buildSummaryRow('Station Name',
                      scoreProvider.scoreData.stationName ?? 'Not provided'),
                  _buildSummaryRow(
                      'Date of Inspection',
                      scoreProvider.scoreData.dateOfInspection ??
                          'Not provided'),
                  _buildSummaryRow(
                      'Time of Inspection',
                      scoreProvider.scoreData.timeOfInspection ??
                          'Not provided'),
                  _buildSummaryRow('Contractor Name',
                      scoreProvider.scoreData.contractorName ?? 'Not provided'),
                  _buildSummaryRow('Supervisor Name',
                      scoreProvider.scoreData.supervisorName ?? 'Not provided'),
                  _buildSummaryRow('Inspector Name',
                      scoreProvider.scoreData.inspectorName ?? 'Not provided'),
                  _buildSummaryRow(
                      'Number of Coaches',
                      scoreProvider.scoreData.numberOfCoaches?.toString() ??
                          'Not provided'),
                ],
              ),
            ),
          ),

          // Coach Scores Summary
          Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coach Scores Summary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                  ),
                  SizedBox(height: 12),
                  ...scoreProvider.scoreData.coachScores.entries.map((entry) {
                    final coachData = entry.value;
                    double totalScore = 0;
                    int scoreCount = 0;

                    // Calculate average score for coach
                    coachData.toiletScores.forEach((toiletId, toiletScore) {
                      if (toiletScore.cleaningScore != null) {
                        totalScore += toiletScore.cleaningScore!;
                        scoreCount++;
                      }
                      if (toiletScore.completenessScore != null) {
                        totalScore += toiletScore.completenessScore!;
                        scoreCount++;
                      }
                      if (toiletScore.hygieneScore != null) {
                        totalScore += toiletScore.hygieneScore!;
                        scoreCount++;
                      }
                      if (toiletScore.pressureScore != null) {
                        totalScore += toiletScore.pressureScore!;
                        scoreCount++;
                      }
                      if (toiletScore.wipingScore != null) {
                        totalScore += toiletScore.wipingScore!;
                        scoreCount++;
                      }
                      if (toiletScore.doorStepScore != null) {
                        totalScore += toiletScore.doorStepScore!;
                        scoreCount++;
                      }
                      if (toiletScore.freshenerScore != null) {
                        totalScore += toiletScore.freshenerScore!;
                        scoreCount++;
                      }
                      if (toiletScore.mosquitoScore != null) {
                        totalScore += toiletScore.mosquitoScore!;
                        scoreCount++;
                      }
                    });

                    coachData.doorwayScores.forEach((doorId, score) {
                      if (score != null) {
                        totalScore += score;
                        scoreCount++;
                      }
                    });

                    coachData.vestibuleScores.forEach((vestibuleId, score) {
                      if (score != null) {
                        totalScore += score;
                        scoreCount++;
                      }
                    });

                    double averageScore =
                        scoreCount > 0 ? totalScore / scoreCount : 0;

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Coach ${entry.key}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getScoreColor(averageScore),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              averageScore.toStringAsFixed(1),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Platform Return Summary
          Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Platform Return Activities',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                  ),
                  SizedBox(height: 12),
                  ...scoreProvider.scoreData.platformReturnScores.entries
                      .map((entry) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _getPlatformReturnTitle(entry.key),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  _getScoreColor(entry.value?.toDouble() ?? 0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              entry.value?.toString() ?? 'N/A',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Overall Score Summary
          /* Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Score',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                       // color: _getScoreColor(scoreProvider.calculateOverallScore()),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            scoreProvider.calculateOverallScore().toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Overall Score',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          */
          SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: scoreProvider.isLoading
                  ? null
                  : () {
                      _showSubmitConfirmationDialog(scoreProvider);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: scoreProvider.isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Submitting...'),
                      ],
                    )
                  : Text(
                      'Submit Inspection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),

          SizedBox(height: 16),

          // Previous Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _tabController.animateTo(4),
              child: Text('Previous'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 8.0) return Colors.green;
    if (score >= 6.0) return Colors.orange;
    if (score >= 4.0) return Colors.red;
    return Colors.grey;
  }

  String _getPlatformReturnTitle(String key) {
    switch (key) {
      case 'cleaning_wiping_toilet':
        return 'Cleaning and wiping of toilet area';
      case 'interior_cleaning':
        return 'Interior Cleaning of compartments';
      case 'cleaning_wiping_required':
        return 'Cleaning & wiping if required';
      case 'floor_including_area':
        return 'Floor including area under seats/berths';
      case 'disposal_garbage':
        return 'Disposal of garbage';
      default:
        return key;
    }
  }

  void _showSubmitConfirmationDialog(ScoreProvider scoreProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Submission'),
          content: Text(
            'Are you sure you want to submit this inspection? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                scoreProvider.submitForm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

// Helper Widgets
class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionHeader({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}

class FormTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final Function(String) onChanged;
  final bool isRequired;
  final String? hint;
  final TextInputType? keyboardType;

  const FormTextField({
    Key? key,
    required this.label,
    this.initialValue,
    required this.onChanged,
    this.isRequired = false,
    this.hint,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          hintText: hint,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        onChanged: onChanged,
        validator: isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              }
            : null,
      ),
    );
  }
}

class CoachSection extends StatelessWidget {
  final String coachId;
  final Widget child;

  const CoachSection({
    Key? key,
    required this.coachId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coach $coachId',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
            ),
            SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
