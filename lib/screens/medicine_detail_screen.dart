import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';
import '../models/medicine.dart';

class MedicineDetailScreen extends StatelessWidget {
  final Medicine medicine;

  const MedicineDetailScreen({Key? key, required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicineProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(medicine.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              // 编辑功能可以后续添加
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 药品信息卡片
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.local_pharmacy,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medicine.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '药品详情',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildInfoRow('用量说明', medicine.dosage.isNotEmpty ? medicine.dosage : '未设置'),
                    SizedBox(height: 12),
                    _buildInfoRow('服药频率', _getFrequencyDisplay(medicine.frequency)),
                    SizedBox(height: 12),
                    _buildInfoRow('服药时间', medicine.schedule.join(', ')),
                    SizedBox(height: 12),
                    _buildInfoRow('添加日期', 
                      '${medicine.createdAt.year}-${medicine.createdAt.month.toString().padLeft(2, '0')}-${medicine.createdAt.day.toString().padLeft(2, '0')}'),
                    SizedBox(height: 12),
                    _buildInfoRow('状态', medicine.isActive ? '启用' : '停用'),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // 快速操作区域
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '今日状态',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // 今日是否已服用
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: provider.isMedicineTakenToday(medicine.id) 
                          ? Colors.green[50] 
                          : Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            provider.isMedicineTakenToday(medicine.id) 
                              ? Icons.check_circle 
                              : Icons.access_time,
                            color: provider.isMedicineTakenToday(medicine.id) 
                              ? Colors.green 
                              : Colors.orange,
                          ),
                          SizedBox(width: 12),
                          Text(
                            provider.isMedicineTakenToday(medicine.id) 
                              ? '今日已服用' 
                              : '今日待服用',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: provider.isMedicineTakenToday(medicine.id) 
                                ? Colors.green[700] 
                                : Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // 标记服用按钮
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: provider.isMedicineTakenToday(medicine.id) 
                          ? null 
                          : () {
                              provider.markAsTaken(medicine.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('已标记 "${medicine.name}" 为已服用'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: provider.isMedicineTakenToday(medicine.id) 
                            ? Colors.grey 
                            : Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          provider.isMedicineTakenToday(medicine.id) 
                            ? '已标记服用' 
                            : '标记已服用',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // 历史记录
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '服药历史',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // 这里可以添加历史记录列表
                    Consumer<MedicineProvider>(
                      builder: (context, provider, child) {
                        final intakes = provider.intakes
                            .where((intake) => intake.medicineId == medicine.id)
                            .take(5) // 只显示最近5条
                            .toList();
                        
                        if (intakes.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                '暂无服药记录',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          );
                        }
                        
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: intakes.length,
                          separatorBuilder: (context, index) => Divider(height: 1),
                          itemBuilder: (context, index) {
                            final intake = intakes[index];
                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                '${intake.time.hour.toString().padLeft(2, '0')}:${intake.time.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: intake.note.isNotEmpty 
                                ? Text(intake.note) 
                                : null,
                              trailing: Text(
                                '${intake.time.month}/${intake.time.day}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _getFrequencyDisplay(String frequency) {
    switch (frequency) {
      case 'daily':
        return '每日一次';
      case 'twice_daily':
        return '每日两次';
      case 'three_times_daily':
        return '每日三次';
      default:
        return '自定义';
    }
  }
}