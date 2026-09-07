#!/usr/bin/env python3
"""
UVM 日志格式化工具
用法: python3 uvm_log_format.py <input.log> [output.log]
"""

import re
import sys
from pathlib import Path

def format_uvm_log(input_file, output_file):
    """格式化 UVM 日志"""

    # UVM 日志正则表达式
    uvm_pattern = re.compile(
        r'^UVM_(INFO|WARNING|ERROR|FATAL)\s+'
        r'([^\s]+?)\s*'           # 文件路径
        r'(?:\((\d+)\))?\s*'      # 行号
        r'@\s*([\d.]+[a-z]*s?)\s*:\s*'  # 时间
        r'([^\s]+)\s+'            # scope
        r'\[([^\]]+)\]\s+'        # message ID
        r'(.*)$'                  # 消息内容
    )

    formatted_lines = []

    with open(input_file, 'r') as f:
        for line in f:
            line = line.rstrip()
            match = uvm_pattern.match(line)

            if match:
                severity, filepath, line_num, time, scope, msg_id, message = match.groups()

                # 只保留文件名
                filename = Path(filepath).name

                # 格式化输出
                line_num_str = line_num if line_num else "?"

                # 对齐格式
                formatted = (
                    f"#{time:>4}  "
                    f"UVM_{severity:<7} "
                    f"{filename:<20}({line_num_str:>3}) : "
                    f"{scope:<37} "
                    f"[{msg_id:<13}] : "
                    f"{message}"
                )

                formatted_lines.append(formatted)
            else:
                # 非 UVM 行保持原样
                formatted_lines.append(line)

    # 写入输出文件
    with open(output_file, 'w') as f:
        f.write('\n'.join(formatted_lines) + '\n')

    return formatted_lines

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 uvm_log_format.py <input.log> [output.log]")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else "formatted_sim.log"

    if not Path(input_file).exists():
        print(f"Error: Input file '{input_file}' not found!")
        sys.exit(1)

    formatted_lines = format_uvm_log(input_file, output_file)

    print(f"Formatted log saved to: {output_file}")
    print("\nPreview (first 10 UVM lines):")

    count = 0
    for line in formatted_lines:
        print(line)
        # if line.startswith('#'):
        #     print(line)
        #     count += 1
        #     if count >= 10:
        #         break

if __name__ == "__main__":
    main()