# 4 — WireGuard Keypair Generation

I don’t store persistent `privatekey` or `publickey` files on disk.  
Whenever I create or rotate a tunnel, I generate fresh keypairs and paste them  
directly into my `.conf` files.

To make that fast and readable, I use a small inline script (run directly in SSH)  
that prints **two full keypairs** (A and B) with very clear spacing.  
This gives me a clean “workspace” to copy from without having to scroll around.

The formatting rules:

- 3 blank lines before Keypair A  
- 1 blank line between A-Private and A-Public  
- 3 blank lines before Keypair B  
- 1 blank line between B-Private and B-Public  
- 3 blank lines at the end  

This layout keeps everything visually separated so I don’t accidentally paste  
the wrong key into the wrong tunnel.

---

## 🔐 Script: Generate Two WireGuard Keypairs (A and B)

Run this directly on any node that has `wg` installed:

```bash
(
  # 3 blank lines before A
  echo -e "\n\n\n"

  # --- Keypair A ---
  A_PRIV=$(wg genkey)
  A_PUB=$(echo "$A_PRIV" | wg pubkey)

  echo "A-Private-Key: $A_PRIV"
  echo ""
  echo "A-Public-Key:  $A_PUB"

  # 3 blank lines before B
  echo -e "\n\n\n"

  # --- Keypair B ---
  B_PRIV=$(wg genkey)
  B_PUB=$(echo "$B_PRIV" | wg pubkey)

  echo "B-Private-Key: $B_PRIV"
  echo ""
  echo "B-Public-Key:  $B_PUB"

  # 3 blank lines at the end
  echo -e "\n\n\n"
)
```

---

## Example Output (Structure Only)

```
<3 blank lines>

A-Private-Key: +PtKg5Em5OADx2DRp586R883hHKnm+4o9QLJwElNzUs=

A-Public-Key:  auwZwPsVjIBhkxdMreOAt0JhyqWc7XNQ0i7sVGk/3XI=

<3 blank lines>

B-Private-Key: 0C2Vhrb/lhMFlTILmV4qXzDIBC/mxLWwWpBsk/GIE0g=

B-Public-Key:  KOTaXQhIGHWp1hhNtjU/RvRRgquEYBLXggxjoFw2Qgk=


<3 blank lines>
```

I then use the keypairs like this:

- **A-Private-Key** goes into the `[Interface]` section on one device  
- **A-Public-Key** goes into the `[Peer]` section on the *other* device  

Because each WireGuard peer needs:
- its **own private key**, and  
- the **other side's public key**

If I generate a second pair (B), I use it for another tunnel or for another pair of devices.

This approach avoids storing private keys on disk and keeps rotation simple and secure.

