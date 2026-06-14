import 'package:flutter/material.dart';
import 'dart:io';

class ScheduledPickup {
  final String id;
  final DateTime date;
  final String timeSlot;
  final String address;
  final double estimatedWeight;
  final String status; // 'Terjadwal', 'Selesai', 'Dibatalkan'

  ScheduledPickup({
    required this.id,
    required this.date,
    required this.timeSlot,
    required this.address,
    required this.estimatedWeight,
    this.status = 'Terjadwal',
  });

  ScheduledPickup copyWith({
    DateTime? date,
    String? timeSlot,
    String? address,
    double? estimatedWeight,
    String? status,
  }) {
    return ScheduledPickup(
      id: id,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      address: address ?? this.address,
      estimatedWeight: estimatedWeight ?? this.estimatedWeight,
      status: status ?? this.status,
    );
  }
}

class DepositHistory {
  final String type; // 'Plastic', 'Paper', 'Metal', 'Glass'
  final double weight; // in kg
  final String relativeTime; // 'Today', 'Yesterday', etc.

  DepositHistory({
    required this.type,
    required this.weight,
    required this.relativeTime,
  });
}

class TransactionHistory {
  final String title;
  final String type; // 'debit' or 'credit'
  final int points;
  final DateTime date;
  final String status;

  TransactionHistory({
    required this.title,
    required this.type,
    required this.points,
    required this.date,
    this.status = 'Berhasil',
  });
}

class ChallengeItem {
  final String title;
  final String description;
  final String duration;
  final int rewardPoints;
  final int currentProgress;
  final int totalGoal;
  final bool isJoined;
  final bool isCompleted;

  ChallengeItem({
    required this.title,
    required this.description,
    required this.duration,
    required this.rewardPoints,
    required this.currentProgress,
    required this.totalGoal,
    this.isJoined = false,
    this.isCompleted = false,
  });

  ChallengeItem copyWith({
    int? currentProgress,
    bool? isJoined,
    bool? isCompleted,
  }) {
    return ChallengeItem(
      title: title,
      description: description,
      duration: duration,
      rewardPoints: rewardPoints,
      currentProgress: currentProgress ?? this.currentProgress,
      totalGoal: totalGoal,
      isJoined: isJoined ?? this.isJoined,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class BadgeItem {
  final String title;
  final String description;
  final int currentProgress;
  final int totalGoal;
  final String period; // 'DAY', 'WEEK', 'MONTH'
  final bool isUnlocked;

  BadgeItem({
    required this.title,
    required this.description,
    required this.currentProgress,
    required this.totalGoal,
    required this.period,
    this.isUnlocked = false,
  });
}

class LeaderboardUser {
  final String name;
  final int points;
  final int streak;
  final int rank;
  final String change; // '+60', etc.

  LeaderboardUser({
    required this.name,
    required this.points,
    required this.streak,
    required this.rank,
    required this.change,
  });
}

class AppState extends ChangeNotifier {
  // User Profile State
  File? _profileImage;
  File? get profileImage => _profileImage;

  int _viewIndex = 0; // Pastikan variabel penampung index ini ada
    int get viewIndex => _viewIndex;

    // TAMBAHKAN FUNGSI INI:
    void setIndex(int index) {
      _viewIndex = index;
      notifyListeners(); // Wajib agar tampilan (UI) tahu ada perubahan!
    }

  void updateProfileImage(File newImage) {
    _profileImage = newImage;
    notifyListeners();
  }

  String _userName = 'Putra Pratama';
  int _userLevel = 5;
  double _levelProgress = 0.65; // progress bar value 0.0 - 1.0
  int _streakCount = 12;
  int _totalPoints = 2450;
  int _pointsThisWeek = 150;
  double _co2Prevented = 8.3; // in kg
  int _depositCountThisMonth = 14;
  int _totalDepositsCount = 28;

  String _userEmail = 'putra.pratama@gmail.com';
  String _userPhone = '+62 812 3456 7890';
  String _userDOB = '12 Oktober 2000';
  String _userDomisili = 'Batam';
  String _userGender = 'Laki-laki';
  String _referralCode = 'PUTRA24';
  int _friendsInvitedCount = 8;
  int _bonusPointsEarned = 1600;


  // Getters
  String get userName => _userName;
  int get userLevel => _userLevel;
  double get levelProgress => _levelProgress;
  int get streakCount => _streakCount;
  int get totalPoints => _totalPoints;
  int get pointsThisWeek => _pointsThisWeek;
  double get co2Prevented => _co2Prevented;
  int get depositCountThisMonth => _depositCountThisMonth;
  int get totalDepositsCount => _totalDepositsCount;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get userDOB => _userDOB;
  String get userDomisili => _userDomisili;
  String get userGender => _userGender;
  String get referralCode => _referralCode;
  int get friendsInvitedCount => _friendsInvitedCount;
  int get bonusPointsEarned => _bonusPointsEarned;

  // Setters/Updaters
  void updateProfile({
    required String name,
    required String email,
    required String phone,
    required String dob,
    required String domisili,
    required String gender,
  }) {
    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    _userDOB = dob;
    _userDomisili = domisili;
    _userGender = gender;
    notifyListeners();
  }

  // Scheduled Pickups List (mock data)
  final List<ScheduledPickup> _pickups = [
    ScheduledPickup(
      id: 'pickup_1',
      date: DateTime(2026, 3, 31),
      timeSlot: '09:00 - 12:00',
      address: 'Jl. Melati No. 15, Jakarta Selatan',
      estimatedWeight: 8.0,
      status: 'Terjadwal',
    )
  ];

  List<ScheduledPickup> get pickups =>
      _pickups.where((p) => p.status == 'Terjadwal').toList();
  List<ScheduledPickup> get pastPickups =>
      _pickups.where((p) => p.status == 'Selesai').toList();

  void schedulePickup(
      DateTime date, String timeSlot, String address, double weight) {
    final id = 'pickup_${DateTime.now().millisecondsSinceEpoch}';
    _pickups.add(ScheduledPickup(
      id: id,
      date: date,
      timeSlot: timeSlot,
      address: address,
      estimatedWeight: weight,
      status: 'Terjadwal',
    ));
    _depositCountThisMonth += 1;
    _totalDepositsCount += 1;
    notifyListeners();
  }

  void cancelPickup(String id) {
    final index = _pickups.indexWhere((p) => p.id == id);
    if (index != -1) {
      _pickups[index] = _pickups[index].copyWith(status: 'Dibatalkan');
      _depositCountThisMonth = (_depositCountThisMonth - 1).clamp(0, 9999);
      _totalDepositsCount = (_totalDepositsCount - 1).clamp(0, 9999);
      notifyListeners();
    }
  }

  // Recent Deposits
  final List<DepositHistory> _recentDeposits = [
    DepositHistory(type: 'Plastic', weight: 2.5, relativeTime: 'Today'),
    DepositHistory(type: 'Paper', weight: 3.2, relativeTime: 'Yesterday'),
    DepositHistory(type: 'Metal', weight: 1.8, relativeTime: '2 Days ago'),
  ];

  List<DepositHistory> get recentDeposits => _recentDeposits;

  // Transaction Ledger (mock points transactions)
  final List<TransactionHistory> _transactions = [
    TransactionHistory(
        title: 'Tukar 500 poin ke Gopay',
        type: 'debit',
        points: 500,
        date: DateTime(2025, 3, 29)),
    TransactionHistory(
        title: 'Tukar 300 poin ke Ovo',
        type: 'debit',
        points: 300,
        date: DateTime(2025, 3, 29)),
    TransactionHistory(
        title: 'Bonus Referral dari Ahmad',
        type: 'credit',
        points: 200,
        date: DateTime(2025, 3, 29)),
    TransactionHistory(
        title: 'Tukar 500 poin ke Gopay',
        type: 'debit',
        points: 500,
        date: DateTime(2025, 2, 29)),
    TransactionHistory(
        title: 'Tukar 300 poin ke Ovo',
        type: 'debit',
        points: 300,
        date: DateTime(2025, 2, 29)),
    TransactionHistory(
        title: 'Bonus Referral dari Ahmad',
        type: 'credit',
        points: 200,
        date: DateTime(2025, 2, 29)),
  ];

  List<TransactionHistory> get transactions => _transactions;

  void redeemPoints(int points, String target) {
    if (_totalPoints >= points) {
      _totalPoints -= points;
      _transactions.insert(
          0,
          TransactionHistory(
            title: 'Tukar $points poin ke $target',
            type: 'debit',
            points: points,
            date: DateTime.now(),
          ));
      notifyListeners();
    }
  }

  // Challenge List
  final List<ChallengeItem> _challenges = [
    ChallengeItem(
      title: 'Bike to Work',
      description: 'Use bicycle for commute to reduce footprint.',
      duration: '5 days',
      rewardPoints: 400,
      currentProgress: 2,
      totalGoal: 5,
      isJoined: true,
    ),
    ChallengeItem(
      title: 'Pilah 10 kg Minggu Ini',
      description: 'Pilah sampah daur ulang hingga mencapai 10 kg.',
      duration: '7 days',
      rewardPoints: 500,
      currentProgress: 7,
      totalGoal: 10,
      isJoined: true, // Featured
    ),
    ChallengeItem(
      title: 'Zero Single-Use Plastic',
      description: 'Do not use single use bags or straws.',
      duration: '3 days',
      rewardPoints: 250,
      currentProgress: 0,
      totalGoal: 3,
      isJoined: false,
    ),
    ChallengeItem(
      title: 'Eco Clean Up Day',
      description: 'Join community clean up events in your area.',
      duration: '1 day',
      rewardPoints: 600,
      currentProgress: 1,
      totalGoal: 1,
      isJoined: false,
      isCompleted: false,
    ),
    ChallengeItem(
      title: 'Compost Master',
      description: 'Compost kitchen scraps for 2 weeks.',
      duration: '14 days',
      rewardPoints: 800,
      currentProgress: 14,
      totalGoal: 14,
      isJoined: true,
      isCompleted: true,
    ),
  ];

  List<ChallengeItem> get joinedChallenges =>
      _challenges.where((c) => c.isJoined && !c.isCompleted).toList();
  List<ChallengeItem> get availableChallenges =>
      _challenges.where((c) => !c.isJoined).toList();
  List<ChallengeItem> get completedChallenges =>
      _challenges.where((c) => c.isCompleted).toList();

  void joinChallenge(String title) {
    final index = _challenges.indexWhere((c) => c.title == title);
    if (index != -1) {
      _challenges[index] = _challenges[index].copyWith(isJoined: true);
      notifyListeners();
    }
  }

  void progressChallenge(String title, int amount) {
    final index = _challenges.indexWhere((c) => c.title == title);
    if (index != -1) {
      final item = _challenges[index];
      final newProg = (item.currentProgress + amount).clamp(0, item.totalGoal);
      final isComp = newProg >= item.totalGoal;
      _challenges[index] = item.copyWith(
        currentProgress: newProg,
        isCompleted: isComp,
      );
      if (isComp) {
        _totalPoints += item.rewardPoints;
        _pointsThisWeek += item.rewardPoints;
        _transactions.insert(
            0,
            TransactionHistory(
              title: 'Selesai Challenge: ${item.title}',
              type: 'credit',
              points: item.rewardPoints,
              date: DateTime.now(),
            ));
      }
      notifyListeners();
    }
  }

  // Badges list
  final List<BadgeItem> _badges = [
    BadgeItem(
        title: 'Use a reusable bag',
        description: 'Bring bags to shopping',
        currentProgress: 5,
        totalGoal: 5,
        period: 'DAY',
        isUnlocked: true),
    BadgeItem(
        title: 'Bike to work',
        description: 'Ride bicycle to work',
        currentProgress: 3,
        totalGoal: 3,
        period: 'WEEK',
        isUnlocked: true),
    BadgeItem(
        title: 'Avoid single-use straws',
        description: 'No plastic straws',
        currentProgress: 7,
        totalGoal: 7,
        period: 'WEEK',
        isUnlocked: true),
    BadgeItem(
        title: 'Compost food scraps',
        description: 'Compost composting',
        currentProgress: 2,
        totalGoal: 2,
        period: 'DAY',
        isUnlocked: true),
    BadgeItem(
        title: 'Turn off unused lights',
        description: 'Save electricity',
        currentProgress: 8,
        totalGoal: 8,
        period: 'DAY',
        isUnlocked: true),
    BadgeItem(
        title: 'Use refillable water bottle',
        description: 'Zero plastic bottles',
        currentProgress: 4,
        totalGoal: 4,
        period: 'DAY',
        isUnlocked: true),
    BadgeItem(
        title: 'Print double-sided',
        description: 'Save paper sheets',
        currentProgress: 6,
        totalGoal: 6,
        period: 'WEEK',
        isUnlocked: true),
    BadgeItem(
        title: 'Donate old clothes',
        description: 'Reuse old outfits',
        currentProgress: 1,
        totalGoal: 1,
        period: 'MONTH',
        isUnlocked: true),
    BadgeItem(
        title: 'Buy local produce',
        description: 'Support local farms',
        currentProgress: 9,
        totalGoal: 9,
        period: 'WEEK',
        isUnlocked: true),
    BadgeItem(
        title: 'Avoid plastic utensils',
        description: 'Use stainless cutlery',
        currentProgress: 3,
        totalGoal: 3,
        period: 'DAY',
        isUnlocked: true),
    BadgeItem(
        title: 'Fix leaky faucets',
        description: 'Save household water',
        currentProgress: 2,
        totalGoal: 2,
        period: 'MONTH',
        isUnlocked: true),
    BadgeItem(
        title: 'Use energy-efficient bulbs',
        description: 'Replace incandescent',
        currentProgress: 5,
        totalGoal: 5,
        period: 'WEEK',
        isUnlocked: true),
  ];

  List<BadgeItem> get badges => _badges;
  int get unlockedBadgesCount => _badges.where((b) => b.isUnlocked).length;

  // Leaderboard data
  final List<LeaderboardUser> _leaderboardUsers = [
    LeaderboardUser(
        name: 'ery', points: 2450, streak: 12, rank: 1, change: '0'),
    LeaderboardUser(
        name: 'Andi', points: 2120, streak: 8, rank: 2, change: '+10'),
    LeaderboardUser(
        name: 'gui lee', points: 1890, streak: 15, rank: 3, change: '-5'),
    LeaderboardUser(
        name: 'Elara', points: 1820, streak: 7, rank: 4, change: '+60'),
    LeaderboardUser(
        name: 'Kian', points: 1740, streak: 6, rank: 5, change: '+60'),
    LeaderboardUser(
        name: 'Soren', points: 1680, streak: 5, rank: 6, change: '+60'),
    LeaderboardUser(
        name: 'Lyra', points: 1600, streak: 4, rank: 7, change: '+60'),
    LeaderboardUser(
        name: 'Orin', points: 1550, streak: 3, rank: 8, change: '+60'),
    LeaderboardUser(
        name: 'Mirael', points: 1480, streak: 2, rank: 9, change: '+60'),
    LeaderboardUser(
        name: 'Zane', points: 1400, streak: 1, rank: 10, change: '+60'),
  ];

  List<LeaderboardUser> get leaderboardUsers => _leaderboardUsers;

  // AI Scan simulator method
  void simulateAiScanResult(String type, double weight, int pointsGained) {
    _totalPoints += pointsGained;
    _pointsThisWeek += pointsGained;
    _co2Prevented += (weight * 0.12); // Mock CO2 calculation
    _recentDeposits.insert(
        0,
        DepositHistory(
          type: type,
          weight: weight,
          relativeTime: 'Today',
        ));
    _transactions.insert(
        0,
        TransactionHistory(
          title: 'Scan Sampah: $type ($weight kg)',
          type: 'credit',
          points: pointsGained,
          date: DateTime.now(),
        ));
    notifyListeners();
  }
  
}
