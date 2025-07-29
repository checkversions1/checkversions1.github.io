import requests

response = requests.get('https://knowledge.broadcom.com/external/article?legacyId=2143838')
with open('debug-vcenter-server-content.html', 'w', encoding='utf-8') as f:
    f.write(response.text)
print('Saved vCenter Server content') 