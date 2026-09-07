# 1. 基本编译和运行
make all

# 2. 只编译
make compile

# 3. 带 GUI 运行
make gui

# 4. 指定测试用例和随机种子
make run TEST_NAME=adder_test SEED=42

# 5. 设置详细日志等级
make run VERBOSITY=UVM_HIGH

# 6. 运行回归测试（多个种子）
make regress

# 7. 打开 Verdi 查看波形
make verdi

# 8. 收集覆盖率
make coverage
make view_cov

# 9. 清理
make clean
make distclean   # 完全清理

# 10. 查看帮助
make help



注意事项
VCS 路径：请根据实际安装路径修改 VCS_HOME 和 UVM_HOME

License：确保 VCS License 可用

文件路径：根据实际文件存放位置调整 RTL_FILES 和 UVM_FILES

波形查看：如果使用 Verdi，确保 VERDI_HOME 路径正确