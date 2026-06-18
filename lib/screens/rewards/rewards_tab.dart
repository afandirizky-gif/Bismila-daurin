import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../state/app_state.dart';

class RewardsTab extends StatefulWidget {
  const RewardsTab({super.key});

  @override
  State<RewardsTab> createState() => _RewardsTabState();
}

class _RewardsTabState extends State<RewardsTab> {
  int _activeSubTab = 0; // 0: Aktif, 1: Tersedia, 2: Selesai
  final TextEditingController _pointsController = TextEditingController(text: '0');
  String _selectedWallet = 'Gopay';

  final List<String> _subTabs = ['Aktif', 'Tersedia', 'Selesai'];

  @override
  void dispose() {
    _pointsController.dispose();
    super.dispose();
  }

  void _showRedeemDialog(AppState state, int amount, String walletName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Penukaran Berhasil', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
          content: Text('Anda telah menukar $amount poin ke saldo $walletName secara sukses!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _pointsController.text = '0';
                });
              },
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.mintGreen)),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // Goal calculation: target is Rp 25.000 (usually 3000 points).
    const targetPoints = 3000;
    final pointsShort = (targetPoints - appState.totalPoints).clamp(0, targetPoints);
    final goalProgress = (appState.totalPoints / targetPoints).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header stats
            Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 20, right: 20),
              child: Column(
                children: [
                  const Text(
                    'Rewards',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Total Points Coin Banner
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppTheme.accentGold,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.monetization_on_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${appState.totalPoints}',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Total Poin',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Goal Progress Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pointsShort > 0 
                              ? 'Butuh $pointsShort poin lagi untuk reward Rp 25.000' 
                              : 'Anda dapat menukarkan reward Rp 25.000 sekarang!',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: goalProgress,
                            color: AppTheme.mintGreen,
                            backgroundColor: Colors.grey.shade100,
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab Buttons Selector (Aktif, Tersedia, Selesai)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: List.generate(_subTabs.length, (index) {
                  final isSelected = index == _activeSubTab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _activeSubTab = index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.mintGreen : AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _subTabs[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Tab Content Area
            Expanded(
              child: IndexedStack(
                index: _activeSubTab,
                children: [
                  _buildAktifTab(appState),
                  _buildTersediaTab(appState),
                  _buildSelesaiTab(appState),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sub-Tab 1: Aktif (Point conversion & e-wallets list)
  Widget _buildAktifTab(AppState state) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Masukkan Jumlah Poin',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen, fontSize: 14),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pointsController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                decoration: InputDecoration(
                  fillColor: AppTheme.creamBg.withOpacity(0.5),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Conversion rate note (e.g. 10 points = Rp 100)
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _pointsController,
                builder: (context, value, child) {
                  return Center(
                    child: Text(
                      'Estimasi Saldo: Rp ${((int.tryParse(value.text) ?? 0) * 10).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.mintGreen, fontSize: 16),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final entered = int.tryParse(_pointsController.text) ?? 0;
                  if (entered <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan poin lebih dari 0')));
                  } else if (state.totalPoints < entered) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Poin tidak mencukupi')));
                  } else {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        backgroundColor: Colors.white,
                        title: const Text('Konfirmasi Penukaran', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                        content: Text('Apakah Anda yakin ingin menukar $entered poin ke saldo $_selectedWallet?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              final success = await state.redeemPointsApi(entered, _selectedWallet);
                              if (success) {
                                _showRedeemDialog(state, entered, _selectedWallet);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Penukaran poin gagal, coba lagi nanti.')));
                              }
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
                            child: const Text('Tukar'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Tukar'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // E-Wallet Options List
        const Text(
          'Pilih E-Wallet',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen, fontSize: 15),
        ),
        const SizedBox(height: 12),
        _walletRow('Gopay', 'Transfer ke Gopay', 'G', Colors.teal),
        _walletRow('Ovo', 'Transfer ke Ovo', 'O', Colors.purple),
        _walletRow('Dana', 'Transfer ke Dana', 'D', Colors.blue),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _walletRow(String name, String desc, String prefixLetter, Color color) {
    final isSelected = _selectedWallet == name;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Text(prefixLetter, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(desc, style: const TextStyle(fontSize: 12, color: AppTheme.textLight)),
        trailing: Icon(
          isSelected ? Icons.check_circle_rounded : Icons.arrow_forward_ios_rounded,
          color: isSelected ? AppTheme.mintGreen : AppTheme.textLight,
          size: isSelected ? 22 : 16,
        ),
        onTap: () {
          setState(() {
            _selectedWallet = name;
          });
        },
      ),
    );
  }

  // Sub-Tab 2: Tersedia (Referral sharing & list of invited friends)
  Widget _buildTersediaTab(AppState state) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Share Referral Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  'Kode Unikmu',
                  style: TextStyle(fontSize: 14, color: AppTheme.textLight, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppTheme.creamBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Text(
                    state.referralCode,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryGreen,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: const Text('Salin'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryGreen,
                        side: const BorderSide(color: AppTheme.primaryGreen),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: const Text('Bagikan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Shared Stats Row
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text('Teman Diajak', style: TextStyle(color: AppTheme.textLight, fontSize: 12)),
                    const SizedBox(height: 8),
                    Text('${state.friendsInvitedCount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppTheme.primaryGreen)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text('Poin Bonus', style: TextStyle(color: AppTheme.textLight, fontSize: 12)),
                    const SizedBox(height: 8),
                    Text('${state.bonusPointsEarned}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppTheme.primaryGreen)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Invited Friends List
        const Text(
          'Teman Berhasil diajak',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen, fontSize: 15),
        ),
        const SizedBox(height: 12),
        if (state.referralFriends.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('Belum ada teman yang diajak', style: TextStyle(color: AppTheme.textLight))),
          )
        else
          ...state.referralFriends.map((f) {
            String dateStr = '';
            try {
              final date = DateTime.parse(f['joinedAt']);
              final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
              dateStr = '${date.day} ${months[date.month - 1]} ${date.year}';
            } catch (e) {
              dateStr = f['joinedAt'] ?? '';
            }
            return _invitedRow(f['name'] ?? 'Anonim', dateStr, '+${f['bonusPoints']}');
          }),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _invitedRow(String name, String date, String points) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.lightMint,
          child: Text(name[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(date, style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
        trailing: Text(
          points,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14),
        ),
      ),
    );
  }

  // Sub-Tab 3: Selesai (Point transaction ledger)
  Widget _buildSelesaiTab(AppState state) {
    final transactions = state.transactions;
    if (transactions.isEmpty) {
      return const Center(child: Text('Belum ada transaksi.', style: TextStyle(color: AppTheme.textLight)));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const Text(
          'Maret 2025',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen, fontSize: 15),
        ),
        const SizedBox(height: 12),
        ...transactions.map((tx) {
          final isCredit = tx.type == 'credit';
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: Text(tx.status, style: TextStyle(fontSize: 11, color: isCredit ? Colors.green : AppTheme.mintGreen)),
              trailing: Text(
                '${isCredit ? "+" : "-"}${tx.points}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCredit ? Colors.green : Colors.red,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 24),
      ],
    );
  }
}
