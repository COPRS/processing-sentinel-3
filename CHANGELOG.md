# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

- RS-659: S3_L0ACQ Remove priority filters

### Removed

- N/A

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
