# Run ID
The ID must be unique for every shipment.

| LK | 00023 |
| -------- | -------- |
| Country code (2-digits) | Run number |

For example, `LK00023` id is given to the 23rd shipment origin from Sri Lanka.

# Shipper ID
The ID must be unique for every shipper.

| SHP | A | 001 |
| -------- | -------- | -------- |
| Prefix | Shipper type | Number of the shipper |

For direct shippers, Shipper type is not specified and Number of the shipper is 4-digit number.

For example, agent id `SHPA001` is given to the first shipping agent and `SHP0001` is given to the first direct shipper.

# Invoice ID

The ID must be unique for every invoice.

| IN | S | 00023 | A | 001 | 0001 |
| -------- | -------- | -------- | -------- | -------- | -------- |
| Prefix | Country of the shipment |Number of the run | Shipper type | Number of the shipper | Number of the invoice |

For example, `INS00023A0010001` id is given to the invoice of,
- Run number `LK00023`
- Shipper `SHPA001`
