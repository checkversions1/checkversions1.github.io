<<<<<<< HEAD
import requests

response = requests.get('https://knowledge.broadcom.com/external/article?legacyId=2143838')
with open('debug-vcenter-server-content.html', 'w', encoding='utf-8') as f:
    f.write(response.text)
=======
import requests

response = requests.get('https://knowledge.broadcom.com/external/article?legacyId=2143838')
with open('debug-vcenter-server-content.html', 'w', encoding='utf-8') as f:
    f.write(response.text)
>>>>>>> 1f73458c16c71be7418bad7aeb90161665a3624b
print('Saved vCenter Server content') 