# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.2-rc1] - 2022-17-10

### Added
N/A

### Changed
- RS-623 / RS-624: [BUG] [OPS] Sentinel-1 AIO preparation job stuck in GENERATING state with mandatory files not found. Backport from 1.5.0.
  WARNING: When using this version ensure that the configuration 'app.preparation-worker.process.hostname' for the RS Add-on is not set to ${HOSTNAME}, but a static unique name.

### Removed
N/A

## [1.4.1-rc1] - 2022-09-22

### Added
N/A

### Changed
RS-XX: Merging documentation updates from develop into V1.1

### Removed
N/A

## [1.4.0-rc1] - 2022-08-03

### Added
RS-447: Organize End User documentation for S3

### Changed
N/A

### Removed
N/A

## [1.3.0-rc1] - 2022-07-06

### Added
RS-217: Develop S3 ACQ processor as RS-add-on
RS-219: Develop S3 L0P processor as RS-add-on

### Changed
N/A

### Removed
RS-XX: Removed old V1 style processing chains completely

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
