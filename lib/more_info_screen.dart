import 'package:fat2fit/food_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MoreInfoPage extends StatefulWidget {
  const MoreInfoPage({Key? key}) : super(key: key);

  @override
  State<MoreInfoPage> createState() => _MoreInfoPageState();
}

class _MoreInfoPageState extends State<MoreInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: const Color(0xFF2E7D32),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              _buildFormCard(),
            ],
          ),
        ),
      ),
    );
  }
  String? selectedGender = 'Male';
  String? selectedInbody = 'Fat';
  String? selectedStatus = 'This is my first time going to the gym';
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController muscleController = TextEditingController();
  final TextEditingController bodyFatController = TextEditingController();

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.lightGreen,
      title: Text(
        "We Need More\nInformation About You",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: Container(
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xFF2E7D32),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
        ),
      ),
    );
  }

  Widget _buildAgeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Age", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: ageController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Enter your age",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Male'),
                value: 'Male',
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() => selectedGender = value);
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Female'),
                value: 'Female',
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() => selectedGender = value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInbodySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "General Inbody",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: [
            ChoiceChip(
              label: const Text("Fat"),
              selected: selectedInbody == "Fat",
              onSelected: (bool selected) {
                setState(() => selectedInbody = "Fat");
              },
            ),
            ChoiceChip(
              label: const Text("Skinny"),
              selected: selectedInbody == "Skinny",
              onSelected: (bool selected) {
                setState(() => selectedInbody = "Skinny");
              },
            ),
            ChoiceChip(
              label: const Text("Nature"),
              selected: selectedInbody == "Nature",
              onSelected: (bool selected) {
                setState(() => selectedInbody = "Nature");
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        RadioListTile<String>(
          title: const Text('This is my first time going to the gym'),
          value: 'This is my first time going to the gym',
          groupValue: selectedStatus,
          onChanged: (value) {
            setState(() => selectedStatus = value);
          },
        ),
        RadioListTile<String>(
          title: const Text('Practice less than 3 months'),
          value: 'Practice less than 3 months',
          groupValue: selectedStatus,
          onChanged: (value) {
            setState(() => selectedStatus = value);
          },
        ),
        RadioListTile<String>(
          title: const Text('Practice from 3 months to a year'),
          value: 'Practice from 3 months to a year',
          groupValue: selectedStatus,
          onChanged: (value) {
            setState(() => selectedStatus = value);
          },
        ),
        RadioListTile<String>(
          title: const Text('Practice more than one year'),
          value: 'Practice more than one year',
          groupValue: selectedStatus,
          onChanged: (value) {
            setState(() => selectedStatus = value);
          },
        ),
      ],
    );
  }

  Widget _buildInbodyUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Body Measurements",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: const Icon(Icons.monitor_weight_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  prefixIcon: const Icon(Icons.height),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: muscleController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Muscle Mass (kg)',
                  prefixIcon: const Icon(Icons.fitness_center),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: bodyFatController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Body Fat %',
                  prefixIcon: const Icon(Icons.percent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAgeSection(),
          const SizedBox(height: 16),
          _buildGenderSection(),
          const SizedBox(height: 16),
          _buildInbodySection(),
          const SizedBox(height: 16),
          _buildStatusSection(),
          const SizedBox(height: 16),
          _buildInbodyUploadSection(),
          const SizedBox(height: 16),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Get.to(() => const FoodSelectionScreen());
        },
        child: const Text("Next", style: TextStyle(color: Colors.white)),
      ),
    );
  }

}
