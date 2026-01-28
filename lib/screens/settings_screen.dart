import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _remindersEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _theme = 'system';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // 应用信息卡片
          Container(
            margin: EdgeInsets.only(bottom: 20),
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
              children: [
                Icon(
                  Icons.local_pharmacy,
                  size: 60,
                  color: Colors.blue,
                ),
                SizedBox(height: 10),
                Text(
                  '吃药了吗',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '版本 1.0.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // 通知设置
          _buildSectionHeader('通知设置'),
          _buildSwitchItem(
            '启用提醒',
            '接收服药提醒通知',
            _remindersEnabled,
            (value) {
              setState(() {
                _remindersEnabled = value;
              });
            },
          ),
          _buildSwitchItem(
            '声音提醒',
            '通知时播放声音',
            _soundEnabled,
            (value) {
              setState(() {
                _soundEnabled = value;
              });
            },
          ),
          _buildSwitchItem(
            '震动提醒',
            '通知时震动设备',
            _vibrationEnabled,
            (value) {
              setState(() {
                _vibrationEnabled = value;
              });
            },
          ),

          SizedBox(height: 20),

          // 外观设置
          _buildSectionHeader('外观设置'),
          _buildRadioItem(
            '跟随系统',
            'system',
            _theme,
            (value) {
              setState(() {
                _theme = value!;
              });
            },
          ),
          _buildRadioItem(
            '浅色模式',
            'light',
            _theme,
            (value) {
              setState(() {
                _theme = value!;
              });
            },
          ),
          _buildRadioItem(
            '深色模式',
            'dark',
            _theme,
            (value) {
              setState(() {
                _theme = value!;
              });
            },
          ),

          SizedBox(height: 20),

          // 数据管理
          _buildSectionHeader('数据管理'),
          _buildButtonItem(
            '备份数据',
            '将药品数据导出到安全位置',
            Icons.backup,
            Colors.blue,
          ),
          _buildButtonItem(
            '恢复数据',
            '从备份文件恢复药品数据',
            Icons.restore,
            Colors.green,
          ),
          _buildButtonItem(
            '清除数据',
            '删除所有药品和记录（谨慎操作）',
            Icons.delete,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildRadioItem(
    String title,
    String value,
    String groupValue,
    Function(String?) onChanged,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: RadioListTile<String>(
        title: Text(title),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildButtonItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // 按钮点击事件
        },
      ),
    );
  }
}