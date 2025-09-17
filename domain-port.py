# 读取 IP:端口 对应的端口列表
with open('naabu_ip-port.txt', 'r') as f:
    ports = [line.strip().split(':')[1] for line in f if ':' in line]

# 读取域名列表
with open('subdomain.txt', 'r') as f:
    domains = [line.strip() for line in f if line.strip()]

# 生成 domain:port 组合并写入 domain-port.txt
with open('domain-port.txt', 'w') as f:
    for domain in domains:
        for port in ports:
            f.write(f"{domain}:{port}\n")