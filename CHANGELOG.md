# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.14.0] - 2023-08-22

### Added

- N/A

### Changed

- RS-1044: [BUG] Increase default gap thresshold for pug processor
- RS-1052: [BUG] S3 PUG-NTC Execution failed with error code 139 for products SY_2_VG1
- RS-1055: [BUG] Many Sentinel-3 Level-0 products are not generated (at the minimum for type SL_0_SLT, SR_0_CAL\_\_\_)
- RS-1079: [BUG] S3 PUG-STC Execution failed with error code 139 for products SY_2_VG1

### Removed

- N/A

## [1.14.0-rc2] - 2023-07-31

### Added

- RS-778: Homogenisation of CIDL documentation

### Changed

- RS-1036: [BUG] [S3 SL1 v1.14.0-rc1] Error in stream parameters properties
- RS-1038: [BUG] [S3 SL1 v1.14.0-rc1] Incorrect Tasktable delivered
- RS-1042: [BUG] S3-PUG-NTC default configuration prevents addon from being deployed
- RS-1044: [BUG] S3 PUG NTC missing SL_2_FRP products in filter, tasktable routing and pdu config
- RS-1050: [BUG] [OPS] S3 PUG NTC Execution failed on too short product

### Removed

- N/A

## [1.14.0-rc1] - 2023-07-06

### Added

- RS-1023: Updating S3 L0p to version 06.15 (tt updated)

### Changed

- RS-578: Most S3 images was updated on Centos7. Tasktables was updated
- RS-992: [BUG] [OPS] S3 PUG-NRT /usr/local/components/PUG-3.45/bin/PUGCoreProcessor failed fo OL_1_EFR Product
- RS-994: [BUG] [S3-SR1-STC] JobProcessing failed
- RS-1012: [BUG] S3-SL2-NTC fails with exit code 129 on S3A products
- RS-1018: [BUG] [S3 SY2 AOD v1.13.2-rc1] SY2_AOD.bin failed with exit code 129
- RS-1021: [BUG] [OPS] S3 PUG product output duration time not coherent

### Removed

- N/A

## [1.13.2-rc1] - 2023-06-15

### Added

- RS-964: [Documentation] [PRO] [S1] [S3] Missing build documentation

### Changed

- RS-932: [S3] SR1-NRT do not provide missing elements while there is a NOK status.
- RS-973: [S3 PUG NRT] No L1/L2 data generated
- RS-974: [OPS] S3B MW1 CAL Failed "[code 290] [exitCode 138]
- RS-981: [OPS] PUG is not generating data for OL1 ERR
- RS-988: [OPS] PUG is not generating data for L2 products
- RS-989: S3 SL2 SL2.bin failed due to "Could not found the level 1 inputs products covering the given processing time window"
- RS-998: S3 OL1-NTC Default timeout configuration to low

### Removed

- N/A

## [1.13.1-rc1] - 2023-05-17

### Added

- N/A

### Changed

- RS-894: [TRACE] S3-L0P task JobGenerator END trace is not stored on the Elastic Search.
- RS-912: Updated xslt to fix tasktable for S3 SR1 NRT
- RS-936: [S3 SR1 1.12 + WA 912] SR_1_SRA.bin failed with exit code 134

### Removed

- N/A

## [1.13.0-rc1] - 2023-03-30

### Added

- N/A

### Changed

- RS-837: Adding dynamic parameter for hardware name that might prevent the PUG from crashing
- RS-882: Updating tasktables for MW1 0.6.14

### Removed

- N/A

## [1.12.1-rc1] - 2023-03-16

### Added

- N/A

### Changed

- RS-XX: Update README.md

### Removed

- N/A

## [1.12.0-rc1] - 2023-03-08

### Added

- N/A

### Changed

- RS-849: S3-SR1 CAL_AX are never updated
- RS-850: S3-MW1 CAL_AX are never updated
- RS-851: Add facilityName configuration to Sentinel-3 chains

### Removed

- N/A

## [1.11.0-rc1] - 2023-02-23

### Added

- N/A

### Changed

- RS-808: Update tasktable.xslt for S3_OL1 to include Config_Files
- RS-827: Fix stream-application-list.properties for S3_PUG\* chains to reference correct IPF
- RS-828: Update joborder.xslt for S3_PUG\* chains to fix different handling of joborder by PUG IPF
- RS-819: Fix default configuration of S3_SY2_AOD_NTC chain

### Removed

- N/A

## [1.10.0-rc1] - 2023-01-27

### Added

- RS-675: Adding RS-addon MW1 NTC
- RS-676: Adding RS-addon SM2 LI NTC
- RS-677: Adding RS-addon SM2 SI NTC
- RS-678: Adding RS-addon SM2 HY NTC
- RS-699: Adding RS-addon OL2 NTC
- RS-700: Adding RS-addon MW1 STC
- RS-701: Adding RS-addon SR1 STC
- RS-702: Adding RS-addon SM2 LI STC
- RS-703: Adding RS-addon SM2 SI STC
- RS-704: Adding RS-addon SM2 HY STC
- RS-729: Adding RS-addon SL2 FRP NTC
- RS-732: Adding RS-addon SY2 STC
- RS-733: Adding RS-addon SY2 VGS STC
- RS-780: Adding RS-addon PUG STC

### Changed

- RS-769: Enable output estimation for L1 and L2 production chains

### Removed

## [1.9.0-rc1] - 2022-12-15

### Added

- RS-583: Adding RS-addon SY2_VGS_NTC
- RS-673: Adding RS-addon SL2 NTC
- RS-674: Adding RS-addon SR1 NTC
- RS-696: Adding RS-addon SL1 NTC

### Changed

- RS-712: A hotfix was applied that tries to improve performance for L0P by filtering out terminated jobs
- RS-766: Updated tasktable for l0p as it was not in line with the latest IPF version

### Removed

- N/A

## [1.8.0-rc1] - 2022-11-23

### Added

- RS-581: Create S3_SY2_NTC processor as RS add-on
- RS-585: Create S3_SY2_AOD_NTC processor as RS add-on
- RS-587: Perform E2E test with NTC OLCI workflow
- RS-604: Create S3_SL2_FRP (NRT) processor as RS-add-on
- RS-642: Centralized documentation of parameters used within RS add-ons
- RS-670: Create S3_OL1_RAC (NRT) processor as RS add-on
- RS-693: Create S3_OL1_SPC (NRT) processor as RS add-on

### Changed

- N/A

### Removed

- RS-659: S3_L0ACQ Remove priority filters

## [1.7.0-rc1] - 2022-10-26

### Added

- RS-566: Create S3_SM2_HY processor as RS add-on
- RS-567: Create S3_SM2_LI processor as RS add-on
- RS-568: Create S3_SM2_SI processor as RS add-on

### Changed

- RS-433: Realign CFI version with F1 for S3_L0ACQ RS add-on
- RS-580: Upgrading tasktables of CFI for MW1, OL1, OL2, PUG, SL2
- RS-582: Upgrading tasktable for SR1 and adjust simulator
- RS-584: Upgrading tasktable for SL1

### Removed

- N/A

### Known Limitations:

- SL1 is using custom selection policy PolicyIntersectMinNumber. It will be replaced with ValIntersect on startup.
- Ol1, SL1, SOL2, SM2 (all) are using selection policy ValIntersectNoDuplicates. It will be replaced with ValIntersect on startup. Note that this might have a negative performance impact on operational environments. Possible workaround will be tackled by RS-643.

## [1.6.0-rc1] - 2022-09-28

### Added

- RS-502: Develop S3 PUG processor as a RS-add-on
- RS-528: Create S3_SR1 processor as RS add-on
- RS-530: Create S3_MW1 processor as RS add-on
- RS-532: Create S3_SL1 processor as RS add-on
- RS-533: Create S3_SL2 processor as RS add-on

### Changed

- RS-434: Realign CFI version with F1 for S3 L0P RS add-on
- RS-512: Script "S3ACQWrapperScript.sh" failed
- RS-517: Too many loops due to symbolic links on S3 ACQ execution worker
- RS-555: s3-l0p addon: s3-l0p processor fails when an input in the job order is empty
- RS-556: rs-addons S1 and S3: wap timeouts are too low

### Removed

- N/A

## [1.5.0-rc1] - 2022-08-31

### Added

- RS-437: Adding S3_OL1 workflow
- RS-438: Adding S3_OL2 workflow
- RS-498: Adding a house keep service handling timeout scenarios
- RS-501: Changed location where RS Core Components and images are pushed to

### Changed

- RS-497: Update documentation to be easy to use

### Removed

- N/A

## [1.4.2-rc1] - 2022-17-10

### Added

- N/A

### Changed

- RS-623 / RS-624: [BUG] [OPS] Sentinel-1 AIO preparation job stuck in GENERATING state with mandatory files not found. Backport from 1.5.0.
  WARNING: When using this version ensure that the configuration 'app.preparation-worker.process.hostname' for the RS Add-on is not set to ${HOSTNAME}, but a static unique name.

### Removed

- N/A

## [1.4.1-rc1] - 2022-09-22

### Added

- N/A

### Changed

- RS-XX: Merging documentation updates from develop into V1.1

### Removed

- N/A

## [1.4.0-rc1] - 2022-08-03

### Added

- RS-447: Organize End User documentation for S3

### Changed

- N/A

### Removed

- N/A

## [1.3.0-rc1] - 2022-07-06

### Added

- RS-217: Develop S3 ACQ processor as RS-add-on
- RS-219: Develop S3 L0P processor as RS-add-on

### Changed

- N/A

### Removed

- RS-XX: Removed old V1 style processing chains completely

## [0.3.0-rc10] - 2022-02-24

### Added

- RS-282: Fixing issue that S3 ACQ always using simulator

### Changed

- N/A

### Removed

- RS-XX: S3 PUG workflows are removed as they are not planned for V1 anymore

## [0.3.0-rc1] - 2022-01-18

### Added

- RS-151: S3 ACQ containers with real IPFs are build
- RS-156: S3 L0 containers with real IPFs are build

### Changed

- N/A

### Removed

- RS-XX: S3 PUG workflows are removed as they are not planned for V1 anymore

## [0.2.0-rc1] - 2021-12-15

### Added

- RS-105: Integration of S3 Acquisition Workflow into S1PRO software
- RS-106: Integration of S3 L0P workflow
- RS-127: Management of PUG processing of S3 L0 products

### Changed

- N/A

### Removed

- N/A

## [0.1.0-rc1] - 2021-11-17

### Added

- RS-96: A mission identifier is added to traces in order to allow identification of mission

### Changed

- RS-109: Migration of Sentinel-3 CGS Transformation configuration into RS
- RS-113: Migrating existing S1PRO repository structure in the repository structure from the consortium

### Removed

- N/A
