根據您提供的函數，這裡列出了 JWT 算法及對應的 OpenSSL 命令來進行數字簽名。注意，對於使用私鑰的算法，假設已經生成了相應的私鑰文件。

### HMAC 算法
使用 HMAC (基於哈希的消息認證碼) 和 SHA-2 系列哈希函數：

- **HS256**（HMAC 使用 SHA-256）
  ```bash
  openssl dgst -sha256 -hmac [key]
  ```
- **HS384**（HMAC 使用 SHA-384）
  ```bash
  openssl dgst -sha384 -hmac [key]
  ```
- **HS512**（HMAC 使用 SHA-512）
  ```bash
  openssl dgst -sha512 -hmac [key]
  ```

### RSA 算法
使用 RSA 密鑰進行簽名：

- **RS256**（RSA 使用 SHA-256）
  ```bash
  openssl dgst -sha256 -sign [private_key.pem]
  ```
- **RS384**（RSA 使用 SHA-384）
  ```bash
  openssl dgst -sha384 -sign [private_key.pem]
  ```
- **RS512**（RSA 使用 SHA-512）
  ```bash
  openssl dgst -sha512 -sign [private_key.pem]
  ```

### ECDSA 算法
使用 ECDSA（橢圓曲線數字簽名算法）：

- **ES256**（ECDSA 使用 SHA-256）
  ```bash
  openssl dgst -sha256 -sign [ec_private_key.pem]
  ```
- **ES256K**（ECDSA 使用 SHA-256，針對 secp256k1 的變體）
  ```bash
  openssl dgst -sha256 -sign [ec_private_key.pem]
  ```
- **ES384**（ECDSA 使用 SHA-384）
  ```bash
  openssl dgst -sha384 -sign [ec_private_key.pem]
  ```
- **ES512**（ECDSA 使用 SHA-512）
  ```bash
  openssl dgst -sha512 -sign [ec_private_key.pem]
  ```

### RSA PSS 算法
使用 RSA PSS（概率簽名方案）：

- **PS256**（RSA PSS 使用 SHA-256）
  ```bash
  openssl dgst -sha256 -sigopt rsa_padding_mode:pss -sign [private_key.pem]
  ```
- **PS384**（RSA PSS 使用 SHA-384）
  ```bash
  openssl dgst -sha384 -sigopt rsa_padding_mode:pss -sign [private_key.pem]
  ```
- **PS512**（RSA PSS 使用 SHA-512）
  ```bash
  openssl dgst -sha512 -sigopt rsa_padding_mode:pss -sign [private_key.pem]
  ```

### EdDSA 算法
使用 EdDSA（愛德華曲線數字簽名算法）：

- **EdDSA**（通常用於 Ed25519）
  ```bash
  openssl dgst -sign [ed_private_key.pem] (注意，具體的命令取決於 OpenSSL 版本和對 EdDSA 的支援)
  ```

這些命令提供了基礎的方法來生成對應的簽名，用於驗證和身份認證的過程中。在實際使用中，您需要替換 `[key]`、`[private_key.pem]`、`[ec_private_key.pem]`、`[ed_private_key.pem]` 等佔位符為實際的密鑰文件路徑或者密鑰本身。