### Encrypted KYC on fhEVM : FHE + blockchain


- user has access to aadhar details
- govt can audit details
- company does not have access to details


Authentication: User authenticates using a trusted government ID  Aadhar

Data Storage: Instead of storing images, we securely store verified details like age, Aadhar number hash, and credit score on the blockchain.

Access Control: Implement access control mechanisms,  allowing authorized government audit option

Verification: Companies can verify necessary attributes (e.g., "Is age > 18?", "Is credit score above X?") using  Fully Homomorphic Encryption (FHE), without accessing the raw underlying user data.
