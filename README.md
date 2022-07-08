# production-sentinel3

:arrow_heading_up: Go back to the [Reference System Software repository](https://github.com/COPRS/reference-system-software) :arrow_heading_up:

# Installation Manual

## Acroynms

| Abbreviation | Definition |
|---|---|
| COPRS | Copernicus Reference System |
| CPU | Central Processing Unit
| DB | Database |
| EDRS | European Data Relay Satellite |
| IPF | Instrument Processing Facility |
| L0 | Level-0 |
| L1 | Level-1 |
| L2| Level-2|
| RAM | Random Access Memory |
| RS | Reference System |
| S3 | Sentinel-3 |
| SCDF | Spring Cloud Dataflow |
| SpEL | Sprint Expression Language |
| OBS | Object Storage |



## Overview

Within this repository you can find the RS Add-ons the for the Sentinel-3 mission. Each RS-Add-on contains a mission specific workflow that can be deployed on its own and adding the processing preparation as well as the scientific processor that processes the satellite data.

The following figure provides an overview about how the different RS Add-ons are chained into each other when all are deployed:

![overview](./media/rs_addons_s3_overview.png "Overview")

The S3 ACQ wrapper contains the IPFs DDC, L0Pre and L0Post processor as a single step and will process EDRS Sessions into S3 granules. These granules are processed by the L0P processor into S3 L0 products.

The following individual processing chains are available:
* [S3 ACQ](./s3-acq/doc/ReleaseNote.md)
* [S3 L0P](./s3-l0p/doc/ReleaseNote.md)

For more information, please consult [https://sentinels.copernicus.eu/web/sentinel/missions/sentinel-3](https://sentinels.copernicus.eu/web/sentinel/missions/sentinel-3)