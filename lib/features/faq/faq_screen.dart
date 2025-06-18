import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  static const List<Map<String, String>> faqs = [
    {
      "question": "What will I get with the Community Subscription Membership for ₹99/month?",
      "answer": "As a YBT member, you gain access to directly contact verified owners of JDM cars and modified bikes for 30 days. This allows you to inquire and engage with sellers personally to ensure a seamless buying experience."
    },
    {
      "question": "What is the importance of YBT Premium when selling a car or bike?",
      "answer": "YBT Premium ensures your listing surpasses others by appearing at the top of the marketplace. This increases visibility, attracting more qualified buyers and expediting your sale."
    },
    {
      "question": "Can I buy a JDM car or modified bike located in a different state or city?",
      "answer": "Yes, chose Filter - Location - after personally connecting with the vehicle's owner and finalizing the deal, you can select a category pickup option. Confirm your Payment - A pickup truck will then deliver the vehicle to your requested address."
    },
    {
      "question": "Does YBT assure there's no damage on any listings?",
      "answer": "YBT encourages buyers to connect directly with vehicle owners after subscribing to a Community Membership. We recommend requesting a video call to examine the car or bike online for your satisfaction, especially if you're purchasing from another city or state."
    },
    {
      "question": "What are YBT Premium Cars?",
      "answer": "YBT Premium Cars are vehicles certified by the YBT workshop. These come with a comprehensive health certificate and complimentary paperwork transfer to ensure a smooth purchase experience."
    },
    {
      "question": "What happens if a car or bike event is canceled after I've purchased tickets?",
      "answer": "In case of cancellation, YBT guarantees a full refund within the promised timeframe, credited directly to your respective account."
    },
    {
      "question": "What if I don't subscribe to the Community Membership?",
      "answer": "Without a subscription, you can still view pictures and videos of listed JDM cars and Modified bikes. However, you won't have access to detailed specifications or the owner's contact information."
    },
    {
      "question": "Does the Community Membership give access to both cars and bikes?",
      "answer": "Yes, the Community Membership provides access to both JDM cars and modified bikes for a minimum of 30 days."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
      ),
      backgroundColor: AppTheme.primaryBlack,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Card(
            color: AppTheme.secondaryBlack,
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              collapsedIconColor: AppTheme.textWhite,
              iconColor: AppTheme.accentRed,
              title: Text(
                faq["question"]!,
                style: const TextStyle(color: AppTheme.textWhite, fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    faq["answer"]!,
                    style: const TextStyle(color: AppTheme.textGrey, fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 