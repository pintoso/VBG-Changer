# Monitor Script ([`monitor_valorant_close.bat`](https://github.com/pintoso/VBG-Changer/blob/main/decoded-base64/monitor_valorant_close.bat))

This script's code is stored in Base64 format inside the main [`VGB-Changer.bat`](https://github.com/pintoso/VBG-Changer/blob/main/VGB-Changer.bat) file. It is decoded and executed automatically.

This [source code](https://github.com/pintoso/VBG-Changer/blob/main/decoded-base64/monitor_valorant_close.bat) is provided for **inspection and transparency**.

---

### Why Use Base64 Encoding?

Using Base64 is the most optimized and reliable way to embed one script inside another without causing errors.

When a batch script (`.bat`) tries to create another batch script using simple `echo` commands, it runs into major issues with special characters like `|`, `>`, `<`, `&`, and `%`.


### What monitor_valorant_close.bat does?

1.  Continuously checks if the `Valorant.exe` process is running.
2.  Once the game is closed, it restores the original menu videos from the backup folder (`.temp/wallpaper.old`).
3.  The script then terminates itself.

# Verify base64

You can verify the source code by copying the string and decoding it using an online tool.

**Link:** [**Base64 Decode**](https://www.base64decode.org/)

**Updated string:**
```
QGVjaG8gb2ZmDQpSRU0gMS4wMg0Kc2V0bG9jYWwgRGlzYWJsZURlbGF5ZWRFeHBhbnNpb24NCg0Kc2V0ICJwYXRoRmlsZT0lfmRwMHBhdGgudHh0Ig0Kc2V0ICJyaW90UGF0aD0iDQoNCmlmIGV4aXN0ICIlcGF0aEZpbGUlIiAoDQogICAgZm9yIC9mICJ1c2ViYWNrcSBkZWxpbXM9IiAlJUcgaW4gKCIlcGF0aEZpbGUlIikgZG8gKA0KICAgICAgICBpZiBub3QgZGVmaW5lZCByaW90UGF0aCAoDQogICAgICAgICAgICBzZXQgInJpb3RQYXRoPSUlRyINCiAgICAgICAgKQ0KICAgICkNCikNCg0KaWYgbm90IGRlZmluZWQgcmlvdFBhdGggKA0KICAgIGVuZGxvY2FsDQogICAgZXhpdA0KKQ0KDQpzZXQgIm1lbnU9JXJpb3RQYXRoJVxTaG9vdGVyR2FtZVxDb250ZW50XE1vdmllc1xNZW51Ig0Kc2V0ICJiYWNrdXA9JX5kcDB3YWxscGFwZXIub2xkIg0KDQo6d2FpdGxvb3ANCnRhc2tsaXN0IDI+TlVMIHwgZmluZHN0ciAvSSAiVmFsb3JhbnQuZXhlIFZBTE9SQU5ULVdpbjY0LVNoaXBwaW5nLmV4ZSIgPk5VTA0KaWYgbm90IGVycm9ybGV2ZWwgMSAoDQogICAgdGltZW91dCAvdCAxID5udWwNCiAgICBnb3RvIDp3YWl0bG9vcA0KKQ0KDQpzZXQgIl9fTUVOVT0lbWVudSUiDQpzZXQgIl9fQkFDS1VQPSViYWNrdXAlIg0KcG93ZXJzaGVsbCAtTm9Qcm9maWxlIC1FeGVjdXRpb25Qb2xpY3kgQnlwYXNzIC1Db21tYW5kICJ0cnkgeyAkbWVudVBhdGggPSAkZW52Ol9fTUVOVTsgJGJhY2t1cFBhdGggPSAkZW52Ol9fQkFDS1VQOyBpZiAoVGVzdC1QYXRoIC1MaXRlcmFsUGF0aCAkYmFja3VwUGF0aCkgeyBHZXQtQ2hpbGRJdGVtIC1MaXRlcmFsUGF0aCAkYmFja3VwUGF0aCAtRmlsdGVyICcqLm1wNCcgLUVycm9yQWN0aW9uIFNpbGVudGx5Q29udGludWUgfCBGb3JFYWNoLU9iamVjdCB7ICRiYWNrdXBGaWxlID0gJF8uRnVsbE5hbWU7ICRtZW51RmlsZSA9IEpvaW4tUGF0aCAkbWVudVBhdGggJF8uTmFtZTsgaWYgKFRlc3QtUGF0aCAtTGl0ZXJhbFBhdGggJG1lbnVGaWxlKSB7ICRiYWNrdXBIYXNoID0gKEdldC1GaWxlSGFzaCAtTGl0ZXJhbFBhdGggJGJhY2t1cEZpbGUgLUFsZ29yaXRobSBNRDUpLkhhc2g7ICRtZW51SGFzaCA9IChHZXQtRmlsZUhhc2ggLUxpdGVyYWxQYXRoICRtZW51RmlsZSAtQWxnb3JpdGhtIE1ENSkuSGFzaDsgaWYgKCRiYWNrdXBIYXNoIC1uZSAkbWVudUhhc2gpIHsgQ29weS1JdGVtIC1MaXRlcmFsUGF0aCAkYmFja3VwRmlsZSAtRGVzdGluYXRpb24gJG1lbnVGaWxlIC1Gb3JjZSB9IH0gfSB9IH0gY2F0Y2ggeyB9Ig0KDQplbmRsb2NhbA==
```
