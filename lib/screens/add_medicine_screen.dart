import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/medicine_provider.dart';
import '../models/medicine.dart';

class AddMedicineScreen extends StatefulWidget {
  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _scheduleControllers = <TextEditingController>[];

  String _frequency = 'custom';
  List<String> _schedules = [''];

  @override
  void initState() {
    super.initState();
    _scheduleControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    for (var controller in _scheduleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addScheduleField() {
    setState(() {
      _scheduleControllers.add(TextEditingController());
      _schedules.add('');
    });
  }

  void _removeScheduleField(int index) {
    if (_scheduleControllers.length > 1) {
      setState(() {
        _scheduleControllers.removeAt(index);
        _schedules.removeAt(index);
      });
    }
  }

  void _onFrequencyChanged(String? value) {
    if (value != null) {
      setState(() {
        _frequency = value;
        if (value == 'daily') {
          _schedules = ['08:00'];
          _updateScheduleControllers(['08:00']);
        } else if (value == 'twice_daily') {
          _schedules = ['08:00', '20:00'];
          _updateScheduleControllers(['08:00', '20:00']);
        } else if (value == 'three_times_daily') {
          _schedules = ['08:00', '12:00', '18:00'];
          _updateScheduleControllers(['08:00', '12:00', '18:00']);
        } else {
          // custom
          if (_schedules.isEmpty || _schedules.every((s) => s.isEmpty)) {
            _schedules = [''];
            _updateScheduleControllers(['']);
          }
        }
      });
    }
  }

  void _updateScheduleControllers(List<String> values) {
    // 清除旧控制器
    for (var controller in _scheduleControllers) {
      controller.dispose();
    }
    _scheduleControllers.clear();

    // 创建新控制器
    for (var value in values) {
      _scheduleControllers.add(TextEditingController(text: value));
    }
  }

  Future<void> _saveMedicine() async {
    if (_formKey.currentState!.validate()) {
      // 获取所有时间值
      List<String> scheduleTimes = [];
      for (int i = 0; i < _scheduleControllers.length; i++) {
        String time = _scheduleControllers[i].text.trim();
        if (time.isNotEmpty) {
          // 验证时间格式
          if (_isValidTimeFormat(time)) {
            scheduleTimes.add(time);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('时间格式不正确，请使用 HH:MM 格式，例如 08:00')),
            );
            return;
          }
        }
      }

      if (scheduleTimes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('请至少设置一个服药时间')),
        );
        return;
      }

      // 创建药品对象
      final medicine = Medicine(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        schedule: scheduleTimes,
        frequency: _frequency,
        createdAt: DateTime.now(),
      );

      // 保存到数据库
      final provider = Provider.of<MedicineProvider>(context, listen: false);
      await provider.addMedicine(medicine);

      // 返回并显示成功消息
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('药品 "${medicine.name}" 已添加成功')),
      );
    }
  }

  bool _isValidTimeFormat(String time) {
    final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    return timeRegex.hasMatch(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加药品'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '基本信息',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),

              // 药品名称
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '药品名称 *',
                  hintText: '例如：阿莫西林胶囊',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.local_pharmacy),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入药品名称';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // 用量说明
              TextFormField(
                controller: _dosageController,
                decoration: InputDecoration(
                  labelText: '用量说明',
                  hintText: '例如：每日三次，每次2粒',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              SizedBox(height: 24),

              Text(
                '服药频率',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),

              // 频率选择
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'daily',
                    label: Text('每日一次'),
                    icon: Icon(Icons.calendar_view_day),
                  ),
                  ButtonSegment(
                    value: 'twice_daily',
                    label: Text('每日两次'),
                    icon: Icon(Icons.calendar_view_week),
                  ),
                  ButtonSegment(
                    value: 'three_times_daily',
                    label: Text('每日三次'),
                    icon: Icon(Icons.calendar_today),
                  ),
                  ButtonSegment(
                    value: 'custom',
                    label: Text('自定义'),
                    icon: Icon(Icons.edit),
                  ),
                ],
                selected: {_frequency},
                onSelectionChanged: (Set<String> newSelection) {
                  _onFrequencyChanged(newSelection.first);
                },
              ),
              SizedBox(height: 24),

              if (_frequency == 'custom') ...[
                Text(
                  '服药时间',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16),

                // 动态添加时间输入框
                for (int i = 0; i < _scheduleControllers.length; i++)
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _scheduleControllers[i],
                            decoration: InputDecoration(
                              labelText: '时间 ${i + 1}',
                              hintText: 'HH:MM 格式，例如 08:00',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: Icon(Icons.access_time),
                            ),
                            keyboardType: TextInputType.datetime,
                            validator: (value) {
                              if (i < _scheduleControllers.length - 1 && 
                                  value != null && 
                                  value.trim().isNotEmpty && 
                                  !_isValidTimeFormat(value.trim())) {
                                return '时间格式不正确，请使用 HH:MM 格式';
                              }
                              return null;
                            },
                          ),
                        ),
                        if (_scheduleControllers.length > 1)
                          IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => _removeScheduleField(i),
                          ),
                      ],
                    ),
                  ),

                // 添加时间按钮
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: _addScheduleField,
                    icon: Icon(Icons.add),
                    label: Text('添加时间'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.grey[700],
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],

              SizedBox(height: 24),

              // 保存按钮
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveMedicine,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '保存药品',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}