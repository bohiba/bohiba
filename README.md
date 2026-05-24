# RUN

CMD + SHIFT + V

# User Role

| Role        | Value |
| ----------- | ----- |
| Super Admin | 0     |
| Admin       | 1     |
| Manager     | 2     |
| Truck Owner | 6     |
| Manager     | 7     |
| Driver      | 8     |

# Trip Status Codes

| Code | Status Name   | Description                    |
| ---: | ------------- | ------------------------------ |
|    0 | `Draft`       | Trip created but not finalized |
|    1 | `Pending`     | Awaiting approval / assignment |
|    2 | `Assigned`    | Driver and truck assigned      |
|    3 | `Scheduled`   | Trip scheduled for future      |
|    4 | `In Progress` | Trip has started               |
|    5 | `Completed`   | Trip successfully completed    |
|    6 | `Delayed`     | Trip delayed due to issues     |
|    7 | `On Hold`     | Temporarily paused             |
|    8 | `Cancelled`   | Trip cancelled before start    |
|    9 | `Aborted`     | Trip stopped after start       |
|   10 | `Failed`      | Trip failed due to error       |
|   11 | `Disputed`    | Payment or delivery dispute    |
|   12 | `Closed`      | Final settlement done          |
|   13 | `Archived`    | Historical / read-only trip    |

# User Verification Status Codes

| Code | Status Name               | Meaning                            |
| ---- | ------------------------- | ---------------------------------- |
| 0    | `NOT SUBMITTED`           | User created but no docs submitted |
| 1    | `SUBMITTED`               | Documents submitted                |
| 2    | `UNDER REVIEW`            | Admin reviewing                    |
| 3    | `REJECTED`                | Verification rejected              |
| 4    | `PARTIALLY VERIFIED`      | Some docs verified                 |
| 5    | `VERIFIED`                | Fully verified ✅                  |
| 6    | `SUSPENDED`               | Suspended after verification       |
| 7    | `REVERIFICATION REQUIRED` | Needs re-upload                    |

# Type of Company

| Code | Company Type           | Company Type Name           | Material Role              | Description (Indian Context)                     | Example Type                   |
| ---- | ---------------------- | --------------------------- | -------------------------- | ------------------------------------------------ | ------------------------------ |
| 1    | `GOV_MINE`             | Government Mining Company   | Supplier                   | State or central government mining lease holder  | Odisha Mining Corporation      |
| 2    | `PVT_MINE`             | Private Mining Lease Holder | Supplier                   | Private company holding mining lease             | Tata Steel                     |
| 3    | `CONTRACT_MINER`       | Mining Contractor           | Supplier (Operational)     | Company operating mine on behalf of lease holder | Mining EPC firms               |
| 4    | `CRUSHER_UNIT`         | Crusher / Screening Unit    | Supplier                   | Processes raw ore into sized material            | Local Barbil crushers          |
| 5    | `BENEFICIATION_PLANT`  | Ore Beneficiation Plant     | Supplier                   | Improves ore grade before dispatch               | Iron ore beneficiation units   |
| 6    | `PELLET_PLANT`         | Pellet Manufacturing Plant  | Both                       | Converts iron ore fines into pellets             | AMNS India                     |
| 7    | `SPONGE_IRON_PLANT`    | Sponge Iron / DRI Plant     | Consumer                   | Uses iron ore & coal for sponge iron             | Odisha DRI plants              |
| 8    | `STEEL_PLANT`          | Integrated Steel Plant      | Both                       | Produces finished steel from ore`                | JSW Steel                      |
| 9    | `ROLLING_MILL`         | Rolling / Re-rolling Mill   | Consumer                   | Converts billets into rods, sheets               | Secondary steel units          |
| 10   | `TRADER`               | Mineral Trader              | Both                       | Buys and resells iron ore                        | Ore trading firms              |
| 11   | `EXPORTER`             | Export Company              | Consumer (Domestic Supply) | Purchases ore for export shipment                | Port-based exporters           |
| 12   | `IMPORTER`             | Import-based Industry       | Consumer                   | Imports ore/raw material for processing          | Coastal industries             |
| 13   | `CONSTRUCTION_COMPANY` | Infrastructure Company      | Consumer                   | Uses steel/iron products                         | Larsen & Toubro                |
| 14   | `CEMENT_PLANT`         | Cement Manufacturing Plant  | Consumer                   | Uses limestone, gypsum, etc.                     | Cement industries              |
| 15   | `POWER_PLANT`          | Thermal Power Plant         | Consumer                   | Uses coal                                        | Coal-based plants              |
| 16   | `LOGISTICS_COMPANY`    | Transport Aggregator        | Service                    | Provides fleet movement services                 | Transport Corporation of India |
| 17   | `FLEET_OWNER_COMPANY`  | Large Fleet Owner           | Service                    | Owns multiple trucks for mining routes           | Regional transport firms       |
| 18   | `PORT_OPERATOR`        | Port / Terminal Operator    | Service                    | Handles bulk cargo shipment                      | Paradip Port operators         |
| 19   | `WAREHOUSE_OPERATOR`   | Storage Yard Operator       | Service                    | Maintains mineral stock yards                    | Mineral depots                 |
| 20   | `WEIGHBRIDGE_OPERATOR` | Weighbridge Owner           | Service                    | Certified truck weighing services                | Mining belt weighbridges       |
| 21   | `FINANCE_NBFC`         | Mining Finance Company      | Service                    | Provides truck or working capital loans          | Shriram Finance                |
| 22   | `INSURANCE_PROVIDER`   | Insurance Company           | Service                    | Provides vehicle & cargo insurance               | Tata AIG                       |
| 23   | `FUEL_SUPPLIER`        | Fuel Station Operator       | Service                    | Diesel supply for fleet                          | Indian Oil Corporation         |
| 24   | `TYRE_SUPPLIER`        | Tyre & Spare Parts Company  | Service                    | Supplies tyres for heavy trucks                  | MRF                            |
| 25   | `EQUIPMENT_SUPPLIER`   | Mining Equipment Company    | Service                    | Supplies excavators, dumpers                     | OEM companies                  |

## PHASE 1 – CORE ODISHA MINNING ECOSYSTEM

| Code | Company Type          | Description                                   |
| ---- | --------------------- | --------------------------------------------- |
| 1    | `GOV_MINE`            | Government-owned mining lease holders         |
| 2    | `PVT_MINE`            | Private mining lease holders                  |
| 3    | `CONTRACT_MINER`      | Mining Contractor                             |
| 4    | `POWER_PLANT`         | Power Plant                                   |
| 5    | `CEMENT_PLANT`        | Cement Plant                                  |
| 6    | `CRUSHER_UNIT`        | Ore crushing and screening units              |
| 7    | `SPONGE_IRON_PLANT`   | Direct Reduced Iron (DRI) plants              |
| 8    | `STEEL_PLANT`         | Integrated or mini steel manufacturing plants |
| 9    | `FLEET_OWNER_COMPANY` | Large transport fleet operators               |

## PHASE 2 – PROCESSING AND TRADING EXTENSION

| Code | Company Type          | Description                             |
| ---- | --------------------- | --------------------------------------- |
| 1    | `TRADER`              | Mineral buying and reselling companies  |
| 2    | `BENEFICIATION_PLANT` | Ore grade improvement processing plants |
| 3    | `PELLET_PLANT`        | Iron ore pellet manufacturing plants    |
| 4    | `LOGISTICS_COMPANY`   | Transport aggregators & logistics firms |

## PHASE 3- ECOSYSTEM REVENUE PARTNERS

| Code | Company Type         | Description                          |
| ---- | -------------------- | ------------------------------------ |
| 1    | `FINANCE_NBFC`       | Mining & fleet financing companies   |
| 2    | `INSURANCE_PROVIDER` | Vehicle & cargo insurance providers  |
| 3    | `FUEL_SUPPLIER`      | Diesel & fuel station operators      |
| 4    | `TYRE_SUPPLIER`      | Tyre & heavy vehicle spare suppliers |

## PAHSE 4- ECOSYSTEM SERVICE PROVIDERS

| Code | Company Type           | Description                   |
| ---- | ---------------------- | ----------------------------- |
| 1    | `PORT_OPERATOR`        | Port & terminal operators     |
| 2    | `WAREHOUSE_OPERATOR`   | Mineral stockyard operators   |
| 3    | `WEIGHBRIDGE_OPERATOR` | Weighbridge service providers |
| 4    | `EQUIPMENT_SUPPLIER`   | Mining equipment suppliers    |

# TICKET

| Code | Enum Case     | Label       |
| ---- | ------------- | ----------- |
| 1    | `OPEN`        | Open        |
| 2    | `IN_PROGRESS` | In Progress |
| 3    | `RESOLVED`    | Resolved    |
| 4    | `CLOSED`      | Closed      |

# TICKET PRIORITY

| Code | Enum Case  | Label    |
| ---- | ---------- | -------- |
| 1    | `LOW`      | Low      |
| 2    | `MEDIUM`   | Medium   |
| 3    | `HIGH`     | High     |
| 4    | `CRITICAL` | Critical |

# TICKET CATEGORY

| Value | Enum Case                     | Label                       | Group                  |
| ----- | ----------------------------- | --------------------------- | ---------------------- |
| 101   | `TRIP_NOT_ASSIGNED`           | Trip Not Assigned           | Trip Related           |
| 102   | `TRIP_DELAYED`                | Trip Delayed                | Trip Related           |
| 103   | `WRONG_TRIP_DETAILS`          | Wrong Trip Details          | Trip Related           |
| 104   | `TRIP_CANCELLATION_REQUEST`   | Trip Cancellation Request   | Trip Related           |
| 105   | `TRIP_DISPUTE`                | Trip Dispute                | Trip Related           |
| 201   | `DRIVER_NOT_RESPONDING`       | Driver Not Responding       | Driver Related         |
| 202   | `DRIVER_BEHAVIOR_COMPLAINT`   | Driver Behavior Complaint   | Driver Related         |
| 203   | `DRIVER_DOCUMENTS_ISSUE`      | Driver Documents Issue      | Driver Related         |
| 204   | `DRIVER_AVAILABILITY_PROBLEM` | Driver Availability Problem | Driver Related         |
| 301   | `VEHICLE_BREAKDOWN`           | Vehicle Breakdown           | Vehicle Related        |
| 302   | `WRONG_VEHICLE_ASSIGNED`      | Wrong Vehicle Assigned      | Vehicle Related        |
| 303   | `VEHICLE_DOCUMENTS_ISSUE`     | Vehicle Documents Issue     | Vehicle Related        |
| 304   | `MAINTENANCE_ISSUE`           | Maintenance Issue           | Vehicle Related        |
| 401   | `INVOICE_ISSUE`               | Invoice Issue               | Billing & Payments     |
| 402   | `PAYMENT_NOT_RECEIVED`        | Payment Not Received        | Billing & Payments     |
| 403   | `OVERCHARGE_DISPUTE`          | Overcharge Dispute          | Billing & Payments     |
| 404   | `REFUND_REQUEST`              | Refund Request              | Billing & Payments     |
| 501   | `POD_UPLOAD_ISSUE`            | POD Upload Issue            | Documentation          |
| 502   | `MISSING_DOCUMENTS`           | Missing Documents           | Documentation          |
| 503   | `INCORRECT_DOCUMENTATION`     | Incorrect Documentation     | Documentation          |
| 504   | `COMPLIANCE_ISSUE`            | Compliance Issue            | Documentation          |
| 601   | `APP_NOT_WORKING`             | App Not Working             | Technical Support      |
| 602   | `LOGIN_ISSUE`                 | Login Issue                 | Technical Support      |
| 603   | `DASHBOARD_ERROR`             | Dashboard Error             | Technical Support      |
| 604   | `FEATURE_REQUEST`             | Feature Request             | Technical Support      |
| 605   | `BUG_REPORT`                  | Bug Report                  | Technical Support      |
| 701   | `DAMAGE_CLAIM`                | Damage Claim                | Load / Shipment Issues |
| 702   | `QUANTITY_MISMATCH`           | Quantity Mismatch           | Load / Shipment Issues |
| 703   | `DELIVERY_DELAY`              | Delivery Delay              | Load / Shipment Issues |
| 704   | `LOST_SHIPMENT`               | Lost Shipment               | Load / Shipment Issues |
| 801   | `ACCOUNT_UPDATE_REQUEST`      | Account Update Request      | General Inquiry        |
| 802   | `PROFILE_CHANGES`             | Profile Changes             | General Inquiry        |
| 803   | `INFORMATION_REQUEST`         | Information Request         | General Inquiry        |
| 804   | `OTHER`                       | Other                       | General Inquiry        |

# SITE STATUS

| Value | Code              | Status              |
| ----- | ----------------- | ------------------- |
| 0     | pending           | `Pending Approval`  |
| 1     | active            | `Active`            |
| 2     | under_review      | `Under Review`      |
| 3     | inactive          | `Inactive`          |
| 4     | maintenance       | `Under Maintenance` |
| 5     | limited_operation | `Limited Operation` |
| 6     | suspended         | `Suspended`         |
| 7     | compliance_hold   | `Compliance Hold`   |
| 8     | payment_hold      | `Payment Hold`      |
| 9     | rejected          | `Rejected`          |
| 10    | blacklisted       | `Blacklisted`       |
| 11    | archived          | `Archived`          |

| Code | Status            | Description                                                  | Typical Scenario                           |
| ---- | ----------------- | ------------------------------------------------------------ | ------------------------------------------ |
| 0    | `waiting_outside` | Vehicle is waiting outside the mining site gate              | Truck arrived but not allowed to enter yet |
| 1    | `queued`          | Vehicle is inside queue line waiting for entry or processing | Gate entry queue                           |
| 2    | `called`          | Vehicle has been called/allowed to move toward entry         | Security or operator called the truck      |
| 3    | `entering`        | Vehicle is currently entering the site                       | Passing gate/security check                |
| 4    | `inside_site`     | Vehicle is inside mining premises waiting for loading        | Waiting near loading area                  |
| 5    | `loading`         | Vehicle is currently being loaded                            | Material loading in progress               |
| 6    | `loaded`          | Loading completed                                            | Ready for exit verification                |
| 7    | `exiting`         | Vehicle leaving the site                                     | Passing exit gate                          |
| 8    | `completed`       | Queue process finished                                       | Trip finished at site                      |
| 9    | `cancelled`       | Queue entry cancelled or truck left queue                    | Driver left or trip cancelled              |

### Antigravity Skills

https://github.com/sickn33/antigravity-awesome-skills
