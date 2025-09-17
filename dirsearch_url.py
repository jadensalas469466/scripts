import re

def is_valid_line(line):
    # - 去除首尾空白字符
    # - 如果该行包含 '0B' 且不包含 '->'，则判定为无效，返回 False
    # - 其他情况返回 True
    line = line.strip()
    has_0B = re.search(r'\b0B\b', line) is not None
    has_arrow = re.search(r'(?<!\w)->(?!\w)', line) is not None
    # 只删除含独立 '0B' 且没有 '->' 的行
    if has_0B and not has_arrow:
        return False
    else:
        return True

def main():
    # 定义需要处理的输入文件列表
    input_files = [
        'dirsearch_default.txt',
        'dirsearch_H2-9000低危版本.txt',
        'dirsearch_raft-large-files.txt',
        'dirsearch_raft-large-directories.txt'
    ]
    # 定义输出文件名
    output_file = 'dirsearch_url.txt'
    # 使用集合保存所有有效行，实现自动去重
    unique_lines = set()

    # 遍历所有输入文件
    for file in input_files:
        # 以 utf-8 编码方式打开文件读取
        with open(file, 'r', encoding='utf-8') as f:
            # 跳过文件首行
            next(f, None)
            # 逐行读取文件内容
            for line in f:
                if line.strip() == '':  # 跳过空行
                    continue
                # 判断该行是否有效（符合条件）
                if is_valid_line(line):
                    # 去除行首尾空白后加入集合，实现跨文件去重
                    unique_lines.add(line.strip())

    # 打开输出文件准备写入
    with open(output_file, 'w', encoding='utf-8') as f:
        # 将所有有效且唯一的行排序后写入输出文件（排序可选）
        for line in sorted(unique_lines):
            f.write(line + '\n')

if __name__ == '__main__':
    main()
