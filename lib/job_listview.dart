import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'job.dart';

class JobsListView extends StatelessWidget {
  const JobsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No jobs available"));
        }
        return _jobsListView(context, snapshot.data!);
      },
    );
  }

  Future<List<Job>> _fetchJobs() async {
    var url = Uri.parse("https://remotive.com/api/remote-jobs");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> jobs = jsonResponse['jobs'];

        return jobs
            .map(
              (job) => Job.fromJson({
                "id": job["id"],
                "position": job["title"],
                "company": job["company_name"],
                "description":
                    job["description"].toString().substring(0, 100) + "...",
              }),
            )
            .toList();
      } else {
        throw Exception("Failed to load jobs: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch jobs: $e");
    }
  }

  ListView _jobsListView(BuildContext context, List<Job> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _tile(
          context,
          data[index].position,
          data[index].company,
          Icons.work_outline,
        );
      },
    );
  }

  ListTile _tile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
      ),
      subtitle: Text(subtitle),
      leading: Icon(icon, color: Colors.blue[500]),
      onTap: () {
        final snackBar = SnackBar(
          duration: const Duration(seconds: 1),
          content: Text("Anda memilih $title!"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }
}
