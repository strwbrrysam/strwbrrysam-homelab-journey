# 5 — WireGuard Key Concepts (Understanding Private & Public Keys)

WireGuard uses **public-key cryptography**.  
Each device participating in a tunnel must have **its own keypair**:

- one **PrivateKey** (secret, never shared)  
- one **PublicKey** (safe to share)

A common misunderstanding is thinking the PrivateKey and PublicKey inside a single
`.conf` file must belong to the same keypair.  
**This is NOT how WireGuard works.**

This document explains, step-by-step, how WireGuard keys are used correctly.

---

## 🔑 1. Every device generates its own keypair

For example:

```
HK1 generates:
    HK1-Private-Key
    HK1-Public-Key

UK1 generates:
    UK1-Private-Key
    UK1-Public-Key
```

These keypairs are completely independent and never mixed.

---

## 🔁 2. Public keys are *swapped between devices*

Each device keeps its **own private key**, but it must receive the **other device’s public key**.

Here is the full process:

```text
              (device 1) HK1                               (device 2) UK1
              -----------------                            -----------------
              generates:                                   generates:
                  HK1-Private-Key                              UK1-Private-Key
                  HK1-Public-Key                               UK1-Public-Key


                           HK1-Public-Key   ⇆   UK1-Public-Key
                       (public keys are exchanged between devices)



CONFIG ON HK1:                                         CONFIG ON UK1:
-----------------                                      -----------------
[Interface]                                            [Interface]
PrivateKey = HK1-Private-Key                           PrivateKey = UK1-Private-Key

[Peer]                                                 [Peer]
PublicKey  = UK1-Public-Key                            PublicKey  = HK1-Public-Key

```

This diagram shows the most important rule:

> **Each device uses its own private key + the other device’s public key.**

Never place your own public key in your own config.

---

## 🔧 3. The `[Interface]` block always uses *your own private key*

Examples:

HK1:

```
[Interface]
PrivateKey = HK1-Private-Key
```

UK1:

```
[Interface]
PrivateKey = UK1-Private-Key
```

Your config never contains another device’s private key.

---

## 🔑 4. The `[Peer]` block always uses *the other device’s public key*

HK1 config:

```
[Peer]
PublicKey = UK1-Public-Key
```

UK1 config:

```
[Peer]
PublicKey = HK1-Public-Key
```

This is the “crossover” that creates the secure relationship.

---

## 📌 5. Summary of the pairing logic

```
HK1 config uses:
    HK1-Private-Key  +  UK1-Public-Key

UK1 config uses:
    UK1-Private-Key  +  HK1-Public-Key
```

Both sides know:

- **their own private key** (secret)  
- **the other side’s public key** (shared)  

This is enough for mutual authentication.

---

## 🚫 6. Common mistakes to avoid

### ❌ Putting a private key inside `[Peer]`  
Only public keys go in `[Peer]`.

### ❌ Using your own public key inside your own config  
You must always use the **remote** public key.

### ❌ Sharing your private key  
Never send a private key to another device or paste it into GitHub.

### ❌ Reusing example keys  
Documentation keys must never be used in real tunnels.

---

## 🧪 7. Example (S1: HK1 ↔ UK1)

### HK1 config

```
[Interface]
PrivateKey = HK1-Private-Key

[Peer]
PublicKey = UK1-Public-Key
```

### UK1 config

```
[Interface]
PrivateKey = UK1-Private-Key

[Peer]
PublicKey = HK1-Public-Key
```

---

## ✔ 8. How this fits into my homelab

All templates and `.conf.example` files in this repo follow the same rule:

- `[Interface]` → **local private key**  
- `[Peer]` → **remote public key**  

This is consistent with how WireGuard is designed and keeps the configuration
safe, simple, and predictable.

If you're new to WireGuard, remember this core principle:

> **Private keys stay local.  
> Public keys are exchanged.  
> A config always pairs your private key with the peer’s public key.**
