import 'package:flutter/material.dart';

class ScoreInputTile extends StatelessWidget {
  final String title;
  final int? currentScore;
  final Function(int) onScoreChanged;
  final String? subtitle;

  const ScoreInputTile({
    Key? key,
    required this.title,
    required this.currentScore,
    required this.onScoreChanged,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 4),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(11, (index) {
                return GestureDetector(
                  onTap: () => onScoreChanged(index),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentScore == index
                          ? Colors.blue[600]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: currentScore == index
                            ? Colors.blue[800]!
                            : Colors.grey[400]!,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: TextStyle(
                          color: currentScore == index
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
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
      margin: EdgeInsets.all(8),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Text(
              'Coach $coachId',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({
    Key? key,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class FormTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final bool isRequired;
  final String? hint;

  const FormTextField({
    Key? key,
    required this.label,
    this.initialValue,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.isRequired = false,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label + (isRequired ? ' *' : ''),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue[600]!),
          ),
          labelStyle: TextStyle(
            color: isRequired ? Colors.red[600] : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}

class ScoreSummaryCard extends StatelessWidget {
  final String title;
  final int obtainedScore;
  final int maxScore;
  final double percentage;

  const ScoreSummaryCard({
    Key? key,
    required this.title,
    required this.obtainedScore,
    required this.maxScore,
    required this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Score Obtained',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '$obtainedScore',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maximum Score',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '$maxScore',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Percentage',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: percentage >= 80
                                    ? Colors.green[800]
                                    : percentage >= 60
                                        ? Colors.orange[800]
                                        : Colors.red[800],
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage >= 80
                    ? Colors.green
                    : percentage >= 60
                        ? Colors.orange
                        : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
