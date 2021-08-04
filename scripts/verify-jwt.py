#/usr/bin/env python3

import sys
import json

from base64 import b64decode, urlsafe_b64decode
from typing import Dict

class JwtToken:

    def __init__(self, header: Dict[str, str], payload: Dict[str, str], signature: str):
        self.header = header
        self.payload = payload
        self.signature = signature

RS256 = RSAAlgorithm(SHA256)

def decode_jwt_token(message: str):
    try:
        signing_message, signature_b64 = message.rsplit('.', 1)
        header_b64, message_b64 = signing_message.split('.')
    except ValueError:
        raise Exception('malformed JWS payload')

    header = json.loads(b64decode(header_b64).decode('ascii'))
    payload = b64decode(message_b64 + "=")

    signature = b64decode(signature_b64)

    return JwtToken(
        header, payload, signature
    )


def main():
    print(sys.argv[1])
    jwt = decode_jwt_token(sys.argv[1])
    print(jwt.header)
    print(jwt.payload)
    import pdb; pdb.set_trace()

if __name__ == "__main__":
    main()
