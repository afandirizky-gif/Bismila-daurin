import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

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
  final String id;
  final String title;
  final String description;
  final String duration;
  final int rewardPoints;
  final int currentProgress;
  final int totalGoal;
  final bool isJoined;
  final bool isCompleted;
  final String? lastProgressAt;

  ChallengeItem({
    this.id = '',
    required this.title,
    required this.description,
    required this.duration,
    required this.rewardPoints,
    required this.currentProgress,
    required this.totalGoal,
    this.isJoined = false,
    this.isCompleted = false,
    this.lastProgressAt,
  });

  ChallengeItem copyWith({
    String? id,
    int? currentProgress,
    bool? isJoined,
    bool? isCompleted,
    String? lastProgressAt,
  }) {
    return ChallengeItem(
      id: id ?? this.id,
      title: title,
      description: description,
      duration: duration,
      rewardPoints: rewardPoints,
      currentProgress: currentProgress ?? this.currentProgress,
      totalGoal: totalGoal,
      isJoined: isJoined ?? this.isJoined,
      isCompleted: isCompleted ?? this.isCompleted,
      lastProgressAt: lastProgressAt ?? this.lastProgressAt,
    );
  }

  bool get isOnCooldown {
    if (lastProgressAt == null) return false;
    try {
      final date = DateTime.parse(lastProgressAt!).toLocal();
      final now = DateTime.now();
      return date.year == now.year && date.month == now.month && date.day == now.day;
    } catch (_) {
      return false;
    }
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
  String _userName = 'Putra Pratama';
  String _userLevel = '5';
  double _levelProgress = 0.65; // progress bar value 0.0 - 1.0
  int _streakCount = 12;
  int _totalPoints = 2450;
  int _pointsThisWeek = 150;
  double _co2Prevented = 8.3; // in kg
  double _totalWeightKg = 12.5; // in kg
  int _depositCountThisMonth = 14;
  int _totalDepositsCount = 28;

  int _treesSaved = 0;
  int _waterSavedLiters = 0;
  int _energySavedKwh = 0;

  String _userEmail = 'putra.pratama@gmail.com';
  String _userPhone = '+62 812 3456 7890';
  String _userDOB = '12 Oktober 2000';
  String _userDomisili = 'Batam';
  String _userGender = 'Laki-laki';
  String _referralCode = 'PUTRA24';
  int _friendsInvitedCount = 8;
  int _bonusPointsEarned = 1600;

  // Global Navigation State
  int _mainTabIndex = 2; // Default to Home
  int? _targetDepositViewIndex;

  // Getters
  String get userName => _userName;
  String get userLevel => _userLevel;
  double get levelProgress => _levelProgress;
  int get streakCount => _streakCount;
  int get totalPoints => _totalPoints;
  int get pointsThisWeek => _pointsThisWeek;
  double get co2Prevented => _co2Prevented;
  double get totalWeightKg => _totalWeightKg;
  int get depositCountThisMonth => _depositCountThisMonth;
  int get totalDepositsCount => _totalDepositsCount;
  int get treesSaved => _treesSaved;
  int get waterSavedLiters => _waterSavedLiters;
  int get energySavedKwh => _energySavedKwh;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get userDOB => _userDOB;
  String get userDomisili => _userDomisili;
  String get userGender => _userGender;
  String get referralCode => _referralCode;
  int get friendsInvitedCount => _friendsInvitedCount;
  int get bonusPointsEarned => _bonusPointsEarned;

  int get mainTabIndex => _mainTabIndex;
  int? get targetDepositViewIndex => _targetDepositViewIndex;

  void navigateToTab(int tabIndex, {int? depositViewIndex}) {
    _mainTabIndex = tabIndex;
    if (depositViewIndex != null) {
      _targetDepositViewIndex = depositViewIndex;
    }
    notifyListeners();
  }

  void clearTargetDepositView() {
    if (_targetDepositViewIndex != null) {
      _targetDepositViewIndex = null;
      // Do not notifyListeners to prevent rebuild loop
    }
  }
  
  List<Map<String, dynamic>> depositChartData = [];
  List<ChallengeItem> activeChallengesDashboard = [];
  
  // Tab Challenge Specific Data
  ChallengeItem? featuredChallenge;
  List<ChallengeItem> activeChallenges = [];
  List<ChallengeItem> availableChallenges = [];
  
  bool isLoadingDashboard = false;
  bool isLoadingChallenges = false;

  Future<void> fetchDashboardData() async {
    isLoadingDashboard = true;
    notifyListeners();
    try {
      await fetchPickupsApi();
      final response = await ApiService.get('/dashboard');
      debugPrint('DASHBOARD RESPONSE: \${response.statusCode} - \${response.body}');
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];
        
        _totalPoints = data['points']['total'];
        _userLevel = data['points']['currentLevel'].toString();
        _levelProgress = (data['points']['progressPercent'] ?? 0) / 100.0;
        
        _co2Prevented = (data['co2']['totalSavedKg'] as num).toDouble();
        _totalWeightKg = (data['stats']['totalWeightKg'] as num).toDouble();
        _streakCount = data['stats']['activeDays'];
        
        if (data['stats']['treesSaved'] != null) {
          _treesSaved = data['stats']['treesSaved'];
        }
        if (data['stats']['waterSavedLiters'] != null) {
          _waterSavedLiters = data['stats']['waterSavedLiters'];
        }
        if (data['stats']['energySavedKwh'] != null) {
          _energySavedKwh = data['stats']['energySavedKwh'];
        }
        
        _totalDepositsCount = data['deposits']['totalCount'] ?? 0;
        _depositCountThisMonth = data['deposits']['thisMonth'] ?? 0;
        _pointsThisWeek = data['points']['weeklyDelta'] ?? 0;
        
        // Chart
        final chartList = data['depositChartLast7Days'] as List;
        depositChartData = chartList.map((e) => e as Map<String, dynamic>).toList();
        
        // Active Challenges Dashboard
        final activeList = data['activeChallenges'] as List;
        activeChallengesDashboard = activeList.map((c) => ChallengeItem(
          id: c['id'], // userChallenge id
          title: c['title'],
          description: c['description'],
          duration: '',
          rewardPoints: c['rewardPoints'],
          currentProgress: (c['progress'] as num).toInt(),
          totalGoal: (c['target'] as num).toInt(),
          isJoined: true,
          isCompleted: c['status'] == 'completed',
        )).toList();
      }
    } catch (e) {
      debugPrint('Error fetchDashboardData: \$e');
    }
    isLoadingDashboard = false;
    notifyListeners();
  }

  Future<void> fetchChallengesData() async {
    isLoadingChallenges = true;
    notifyListeners();
    try {
      final response = await ApiService.get('/challenges/overview');
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];
        
        // Featured
        final fc = data['featuredChallenge'];
        if (fc != null) {
          featuredChallenge = ChallengeItem(
            id: fc['id'],
            title: fc['title'],
            description: fc['description'],
            duration: '${fc['durationDays']} hari',
            rewardPoints: fc['rewardPoints'],
            currentProgress: (fc['progress'] as num).toInt(),
            totalGoal: (fc['target'] as num).toInt(),
            isJoined: fc['joined'],
            isCompleted: false, // not provided exactly, but let's assume
            lastProgressAt: fc['lastProgressAt'],
          );
        }
        
        // Active
        final aList = data['activeChallenges'] as List;
        activeChallenges = aList.map<ChallengeItem>((c) => ChallengeItem(
          id: c['id'], // use challengeId for progress API
          title: c['title'],
          description: c['description'],
          duration: '${c['durationDays']} hari',
          rewardPoints: c['rewardPoints'],
          currentProgress: (c['progress'] as num).toInt(),
          totalGoal: (c['target'] as num).toInt(),
          isJoined: true,
          isCompleted: c['status'] == 'completed',
          lastProgressAt: c['lastProgressAt'],
        )).toList();
        
        // Available
        final avList = data['availableChallenges'] as List;
        availableChallenges = avList.map<ChallengeItem>((c) => ChallengeItem(
          id: c['id'],
          title: c['title'],
          description: c['description'],
          duration: '${c['durationDays']} hari',
          rewardPoints: c['rewardPoints'],
          currentProgress: 0,
          totalGoal: 10, // dummy, waiting for schema update if needed
          isJoined: false,
          isCompleted: false,
        )).toList();
      }
    } catch (e) {
      debugPrint('Error fetchChallengesData: \$e');
    }
    isLoadingChallenges = false;
    notifyListeners();
  }

  Future<bool> joinChallengeApi(String challengeId) async {
    try {
      final response = await ApiService.post('/challenges/${challengeId}/join', {});
      if (response.statusCode == 200) {
        await fetchChallengesData();
        await fetchDashboardData();
        return true;
      }
    } catch (e) {
      debugPrint('Error joinChallengeApi: \$e');
    }
    return false;
  }

  Future<String?> progressChallengeApi(String challengeId) async {
    try {
      final response = await ApiService.post('/challenges/${challengeId}/progress', {'amount': 1});
      if (response.statusCode == 200) {
        await fetchChallengesData();
        await fetchDashboardData(); // to update points if completed
        return null; // Success
      } else {
        final body = jsonDecode(response.body);
        return body['error'] ?? 'Terjadi kesalahan sistem';
      }
    } catch (e) {
      debugPrint('Error progressChallengeApi: \$e');
      return 'Koneksi gagal';
    }
  }

  Future<bool> createAndVerifyDepositApi(double weightKg) async {
    try {
      // 0. Fetch a valid Drop Point
      final dpRes = await ApiService.get('/drop-points');
      if (dpRes.statusCode != 200) return false;
      final dpBody = jsonDecode(dpRes.body);
      final dpList = dpBody['data'] as List;
      if (dpList.isEmpty) return false;
      final dropPointId = dpList[0]['id'];

      // 1. Create Pending Deposit
      final createRes = await ApiService.post('/deposits', {
        'dropPointId': dropPointId,
        'categories': [
          {'category': 'Plastik', 'weightKg': weightKg}
        ]
      });

      if (createRes.statusCode == 201) {
        final createBody = jsonDecode(createRes.body);
        final txnId = createBody['data']['transactionId'];

        // 2. Automatically Verify using Operator Key for MVP purposes
        final verifyRes = await ApiService.post(
          '/deposits/$txnId/verify',
          {'categories': [{'category': 'Plastik', 'weightKg': weightKg}]},
          headers: {'x-operator-key': 'operator-dev-key'}
        );

        if (verifyRes.statusCode == 200) {
          await fetchDashboardData(); // Refresh points & co2!
          return true;
        }
      }
    } catch (e) {
      debugPrint('Error createAndVerifyDepositApi: \$e');
    }
    return false;
  }

  // Setters/Updaters
  void updateProfile({
    required String name,
    required String email,
    required String phone,
    required String domisili,
  }) {
    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    _userDomisili = domisili;
    notifyListeners();
  }

  void setUserData(Map<String, dynamic> user) {
    _userName = user['fullName'] ?? _userName;
    _userEmail = user['email'] ?? _userEmail;
    _userPhone = user['phone'] ?? _userPhone;
    _userDomisili = user['address'] ?? _userDomisili;
    _totalPoints = user['totalPoints'] ?? _totalPoints;
    _referralCode = user['referralCode'] ?? _referralCode;
    notifyListeners();
  }

  // Scheduled Pickups List
  List<ScheduledPickup> _pickups = [];

  List<ScheduledPickup> get pickups => _pickups.where((p) => p.status == 'scheduled').toList();
  List<ScheduledPickup> get pastPickups => _pickups.where((p) => p.status == 'completed').toList();

  Future<void> fetchPickupsApi() async {
    try {
      final response = await ApiService.get('/pickups');
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final list = body['data'] as List;
        _pickups = list.map((e) => ScheduledPickup(
          id: e['id'],
          date: DateTime.parse(e['scheduledAt']),
          timeSlot: '${DateTime.parse(e['scheduledAt']).hour}:00 - ${DateTime.parse(e['scheduledAt']).hour + 3}:00', // Mock time slot as backend only stores datetime
          address: e['address'],
          estimatedWeight: (e['estimatedWeightKg'] as num).toDouble(),
          status: e['status'],
        )).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetchPickupsApi: $e');
    }
  }

  // Referral Data
  List<Map<String, dynamic>> _referralFriends = [];
  List<Map<String, dynamic>> get referralFriends => _referralFriends;

  Future<void> fetchReferralData() async {
    try {
      final response = await ApiService.get('/referral/stats');
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];
        _referralCode = data['code'] ?? _referralCode;
        _friendsInvitedCount = data['invited'] ?? 0;
        _bonusPointsEarned = data['totalBonusPoints'] ?? 0;
        _referralFriends = List<Map<String, dynamic>>.from(data['referrals'] ?? []);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetchReferralData: $e');
    }
  }

  Future<bool> schedulePickupApi(DateTime date, String timeSlot, String address, double weight, String category) async {
    try {
      // Backend expects a single DateTime. Let's merge the selected date and timeslot.
      // E.g., '09:00 - 12:00' -> we pick 09:00
      final hourString = timeSlot.split(':')[0];
      final hour = int.tryParse(hourString) ?? 9;
      // Use UTC to ensure .toIso8601String() appends 'Z', which is required by backend Zod validation
      final scheduledAt = DateTime.utc(date.year, date.month, date.day, hour).toIso8601String();

      final response = await ApiService.post('/pickups', {
        'address': address,
        'scheduledAt': scheduledAt,
        'estimatedWeightKg': weight,
        'category': category.toLowerCase(),
      });

      if (response.statusCode == 201) {
        await fetchPickupsApi();
        await fetchDepositHistoryApi();
        return true;
      }
    } catch (e) {
      debugPrint('Error schedulePickupApi: $e');
    }
    return false;
  }

  Future<bool> verifyPickupApi(String pickupId) async {
    try {
      final response = await ApiService.post(
        '/pickups/$pickupId/complete',
        {
          'actualWeightKg': 10.0, // Mock weight for MVP simulation
        },
        headers: {'x-operator-key': 'operator-dev-key'}
      );

      if (response.statusCode == 200) {
        await fetchPickupsApi();
        await fetchDashboardData();
        return true;
      }
    } catch (e) {
      debugPrint('Error verifyPickupApi: \$e');
    }
    return false;
  }

  Future<bool> cancelPickupApi(String pickupId) async {
    try {
      final response = await ApiService.delete('/pickups/$pickupId');
      if (response.statusCode == 200) {
        await fetchPickupsApi();
        return true;
      }
    } catch (e) {
      debugPrint('Error cancelPickupApi: \$e');
    }
    return false;
  }

  // Recent Deposits
  List<DepositHistory> _recentDeposits = [];
  List<DepositHistory> get recentDeposits => _recentDeposits;

  Future<void> fetchDepositHistoryApi() async {
    try {
      final response = await ApiService.get('/deposits/history');
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final list = body['data'] as List;
        
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        
        Map<String, Map<String, dynamic>> categoryData = {
          'plastic': {'type': 'Plastic', 'weight': 0.0, 'last': null},
          'paper': {'type': 'Paper', 'weight': 0.0, 'last': null},
          'metal': {'type': 'Metal', 'weight': 0.0, 'last': null},
        };
        
        for (var txn in list) {
          final cats = txn['categories'] as List;
          final dateStr = txn['createdAt'];
          final date = DateTime.parse(dateStr).toLocal();
          
          for (var c in cats) {
            String typeRaw = c['category'] ?? '';
            String typeLower = typeRaw.toLowerCase();
            
            // Normalize names
            String normalizedKey = typeLower;
            if (typeLower == 'plastik') normalizedKey = 'plastic';
            if (typeLower == 'kertas') normalizedKey = 'paper';
            if (typeLower == 'besi' || typeLower == 'logam') normalizedKey = 'metal';
            
            double weight = (c['weightKg'] as num).toDouble();
            
            if (!categoryData.containsKey(normalizedKey)) {
              // Capitalize first letter for display
              String displayType = typeRaw.isNotEmpty 
                  ? typeRaw[0].toUpperCase() + typeRaw.substring(1) 
                  : 'Unknown';
              categoryData[normalizedKey] = {'type': displayType, 'weight': 0.0, 'last': null};
            }
            
            categoryData[normalizedKey]!['weight'] += weight;
            DateTime? lastDate = categoryData[normalizedKey]!['last'];
            if (lastDate == null || date.isAfter(lastDate)) {
              categoryData[normalizedKey]!['last'] = date;
            }
          }
        }
        
        String getRelTime(DateTime? d) {
          if (d == null) return '-';
          final itemDate = DateTime(d.year, d.month, d.day);
          final diff = today.difference(itemDate).inDays;
          if (diff == 0) return 'Today';
          if (diff == 1) return 'Yesterday';
          return '$diff Days ago';
        }
        
        _recentDeposits = categoryData.values.map((data) {
          return DepositHistory(
            type: data['type'], 
            weight: data['weight'], 
            relativeTime: getRelTime(data['last'])
          );
        }).toList();
        
        // Ensure plastic, paper, metal are first
        _recentDeposits.sort((a, b) {
          final order = {'Plastic': 0, 'Paper': 1, 'Metal': 2};
          int orderA = order[a.type] ?? 99;
          int orderB = order[b.type] ?? 99;
          return orderA.compareTo(orderB);
        });
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetchDepositHistoryApi: $e');
    }
  }

  // Transaction Ledger (mock points transactions)
  final List<TransactionHistory> _transactions = [
    TransactionHistory(title: 'Tukar 500 poin ke Gopay', type: 'debit', points: 500, date: DateTime(2025, 3, 29)),
    TransactionHistory(title: 'Tukar 300 poin ke Ovo', type: 'debit', points: 300, date: DateTime(2025, 3, 29)),
    TransactionHistory(title: 'Bonus Referral dari Ahmad', type: 'credit', points: 200, date: DateTime(2025, 3, 29)),
    TransactionHistory(title: 'Tukar 500 poin ke Gopay', type: 'debit', points: 500, date: DateTime(2025, 2, 29)),
    TransactionHistory(title: 'Tukar 300 poin ke Ovo', type: 'debit', points: 300, date: DateTime(2025, 2, 29)),
    TransactionHistory(title: 'Bonus Referral dari Ahmad', type: 'credit', points: 200, date: DateTime(2025, 2, 29)),
  ];

  List<TransactionHistory> get transactions => _transactions;

  Future<bool> redeemPointsApi(int points, String target) async {
    try {
      final amountRp = points * 10;
      final response = await ApiService.post('/rewards/redeem', {
        'platform': target.toLowerCase(),
        'amountRp': amountRp,
      });

      if (response.statusCode == 201) {
        // Backend deduction was successful, update local state
        await fetchDashboardData(); // this will refresh the points from backend
        // We can also fetch the history if needed
        return true;
      } else {
        final body = jsonDecode(response.body);
        debugPrint('Redeem Error: ${body['error']}');
      }
    } catch (e) {
      debugPrint('Error redeemPointsApi: $e');
    }
    return false;
  }

  // Legacy Mock Challenge lists have been removed/bypassed in favor of dynamic API lists


  // Badges list
  final List<BadgeItem> _badges = [
    BadgeItem(title: 'Use a reusable bag', description: 'Bring bags to shopping', currentProgress: 5, totalGoal: 5, period: 'DAY', isUnlocked: true),
    BadgeItem(title: 'Bike to work', description: 'Ride bicycle to work', currentProgress: 3, totalGoal: 3, period: 'WEEK', isUnlocked: true),
    BadgeItem(title: 'Avoid single-use straws', description: 'No plastic straws', currentProgress: 7, totalGoal: 7, period: 'WEEK', isUnlocked: true),
    BadgeItem(title: 'Compost food scraps', description: 'Compost composting', currentProgress: 2, totalGoal: 2, period: 'DAY', isUnlocked: true),
    BadgeItem(title: 'Turn off unused lights', description: 'Save electricity', currentProgress: 8, totalGoal: 8, period: 'DAY', isUnlocked: true),
    BadgeItem(title: 'Use refillable water bottle', description: 'Zero plastic bottles', currentProgress: 4, totalGoal: 4, period: 'DAY', isUnlocked: true),
    BadgeItem(title: 'Print double-sided', description: 'Save paper sheets', currentProgress: 6, totalGoal: 6, period: 'WEEK', isUnlocked: true),
    BadgeItem(title: 'Donate old clothes', description: 'Reuse old outfits', currentProgress: 1, totalGoal: 1, period: 'MONTH', isUnlocked: true),
    BadgeItem(title: 'Buy local produce', description: 'Support local farms', currentProgress: 9, totalGoal: 9, period: 'WEEK', isUnlocked: true),
    BadgeItem(title: 'Avoid plastic utensils', description: 'Use stainless cutlery', currentProgress: 3, totalGoal: 3, period: 'DAY', isUnlocked: true),
    BadgeItem(title: 'Fix leaky faucets', description: 'Save household water', currentProgress: 2, totalGoal: 2, period: 'MONTH', isUnlocked: true),
    BadgeItem(title: 'Use energy-efficient bulbs', description: 'Replace incandescent', currentProgress: 5, totalGoal: 5, period: 'WEEK', isUnlocked: true),
  ];

  List<BadgeItem> get badges => _badges;
  int get unlockedBadgesCount => _badges.where((b) => b.isUnlocked).length;

  // Leaderboard data
  final List<LeaderboardUser> _leaderboardUsers = [
    LeaderboardUser(name: 'ery', points: 2450, streak: 12, rank: 1, change: '0'),
    LeaderboardUser(name: 'Andi', points: 2120, streak: 8, rank: 2, change: '+10'),
    LeaderboardUser(name: 'gui lee', points: 1890, streak: 15, rank: 3, change: '-5'),
    LeaderboardUser(name: 'Elara', points: 1820, streak: 7, rank: 4, change: '+60'),
    LeaderboardUser(name: 'Kian', points: 1740, streak: 6, rank: 5, change: '+60'),
    LeaderboardUser(name: 'Soren', points: 1680, streak: 5, rank: 6, change: '+60'),
    LeaderboardUser(name: 'Lyra', points: 1600, streak: 4, rank: 7, change: '+60'),
    LeaderboardUser(name: 'Orin', points: 1550, streak: 3, rank: 8, change: '+60'),
    LeaderboardUser(name: 'Mirael', points: 1480, streak: 2, rank: 9, change: '+60'),
    LeaderboardUser(name: 'Zane', points: 1400, streak: 1, rank: 10, change: '+60'),
  ];

  List<LeaderboardUser> get leaderboardUsers => _leaderboardUsers;

  // AI Scan simulator method
  void simulateAiScanResult(String type, double weight, int pointsGained) {
    _totalPoints += pointsGained;
    _pointsThisWeek += pointsGained;
    _co2Prevented += (weight * 0.12); // Mock CO2 calculation
    _recentDeposits.insert(0, DepositHistory(
      type: type,
      weight: weight,
      relativeTime: 'Today',
    ));
    _transactions.insert(0, TransactionHistory(
      title: 'Scan Sampah: $type ($weight kg)',
      type: 'credit',
      points: pointsGained,
      date: DateTime.now(),
    ));
    notifyListeners();
  }
}
