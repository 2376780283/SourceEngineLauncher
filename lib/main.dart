import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io'; 
import 'package:device_info_plus/device_info_plus.dart'; 
import 'dart:ui';

// zzhlife third import
import './widget/BlurCard.dart';
import './splash_screen.dart';
import './components/blur_appbar.dart';
import './components/rounded_underline_tab_indicator.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await _checkPermissions();
  runApp(const MyApp());
}

Future<void> _checkPermissions() async {
  final permissions = [
    Permission.manageExternalStorage,
    Permission.accessMediaLocation,
    if (Platform.isAndroid && await DeviceInfoPlugin().androidInfo.then((info) => info.version.sdkInt >= 33))
      Permission.photos,
  ];  
  final statuses = await permissions.request();  
  if (statuses.values.any((status) => status.isDenied || status.isPermanentlyDenied)) {
    // 引导用户手动开启权限
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Half life2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String? selectedPath;
  bool _hasPermissions = false;
  late TabController _tabController; // Tab控制器
  // 动画
  late AnimationController _hideController;
  late Animation<double> _hideAnimation;
  bool _isToolbarVisible = true;
  @override
  void initState() {
    super.initState();
    loadSavedPath();
    _checkRuntimePermissions();
    
    // 初始化Tab控制器 - 现在使用TickerProviderStateMixin
    _tabController = TabController(length: 2, vsync: this);
    
    // 隐藏动画控制器 - 也使用同一个vsync
    _hideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,  // 关键修改
    );
    
    // 创建向上划出动画
    _hideAnimation = Tween<double>(begin: 0, end: -kToolbarHeight).animate(
      CurvedAnimation(parent: _hideController, curve: Curves.easeInOut)
    );
  }
  
  @override
  void dispose() {
    _hideController.dispose();
    super.dispose();
  }
  Future<void> _checkRuntimePermissions() async {
    final status = await Permission.manageExternalStorage.status;
    setState(() {
      _hasPermissions = status.isGranted;
    });
  }

  Future<void> loadSavedPath() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedPath = prefs.getString('game_path');
    });
    FlutterNativeSplash.remove();
  }

  Future<void> selectPath() async {
    if (!_hasPermissions) {
      _showPermissionAlert();
      return;
    }
    
    final path = await getDirectoryPath();
    if (path != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('game_path', path);
      setState(() {
        selectedPath = path;
      });
      print("已选择路径：$path");
    }
  }
  void _showPermissionAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('需要权限'),
        content: const Text('请授予存储访问权限以选择游戏路径'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('去设置'),
          ),
        ],
      ),
    );
  }

  // 切换工具栏可见状态
  void _toggleToolbar() {
    if (_isToolbarVisible) {
      _hideController.forward();
    } else {
      _hideController.reverse();
    }
    setState(() => _isToolbarVisible = !_isToolbarVisible);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(  // 修复：使用PreferredSize包装
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AnimatedBuilder(
          animation: _hideAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _hideAnimation.value),
              child: AppBar(
                leading: Container(
                  padding: const EdgeInsets.only(left: 20, top: 8),
                  child: Image.asset('assets/images/ic_launcher.png'),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                    child: Container(color: Colors.white.withOpacity(0.25)),
                  ),
                ),
                title: const Text('hl test'),
                // 添加隐藏按钮到右侧
                actions: [
                  IconButton(
                    icon: Icon(_isToolbarVisible 
                      ? Icons.visibility_off 
                      : Icons.visibility),
                    onPressed: _toggleToolbar,
                    tooltip: _isToolbarVisible ? '隐藏工具栏' : '显示工具栏',
                  )
                ],
              ),
            );
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: BlurCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 自定义紧凑型TabBar
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: TabBar(
  controller: _tabController,
  isScrollable: true,
  indicator: RoundedUnderlineTabIndicator( // Use public class name
    width: 28, 
    radius: 4,
    borderSide: BorderSide(width: 3, color: Colors.orange),
  ),
  // Other parameters...
  tabs: [ 


                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.more_horiz, size: 18),
                            SizedBox(width: 6),
                            Text("HOME"),
                          ],
                        ),
                      ),
                      
                     Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.settings, size: 18),
                            SizedBox(width: 6),
                            Text("SETTING"),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                ),
                
                // 页面切换区域
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [

                      Container(
                        padding: const EdgeInsets.all(20),
                        child: const Center(
                          child: Text(
                            "第二页内容待添加",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                       _buildGameSettingsPage(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 游戏设置页内容
  Widget _buildGameSettingsPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedPath != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                '已保存路径: $selectedPath',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ElevatedButton(
            onPressed: selectPath,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('选择游戏路径'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (selectedPath == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请先选择游戏路径')),
                );
                return;
              }
              if (!_hasPermissions) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('需要存储权限才能运行')),
                );
                return;
              }
              const platform = MethodChannel('runIntermediaryActivity');
              try {
                await platform.invokeMethod('$selectedPath');                             
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('启动成功!'))
                );
              } on PlatformException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('启动失败: ${e.message}')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),                                               
            child: const Text('START'),
          ),
          if (!_hasPermissions)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                '需要存储权限才能正常运行',
                style: TextStyle(color: Colors.red[300], fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
