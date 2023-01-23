:arrow_heading_up: Go back to the [Reference System Software repository](https://github.com/COPRS/reference-system-software) :arrow_heading_up:

# Processing Sentinel-3
* [Processing Sentinel 3](#processing-sentinel-3)  
  * [Overview](#overview)
  * [Available RS Addons](#available-rs-addons)
  * [Dependencies](#dependencies)
  * [Deployment](#deployment)
  * [Acroynms](#acroynms)

## Overview

Within this repository you can find the RS Add-ons the for the Sentinel-3 mission. Each RS-Add-on contains a mission specific workflow that can be deployed on its own and adding the processing preparation as well as the scientific processor that processes the satellite data.

 ## Available RS Addons

The following figure provides an overview about how the different RS Add-ons are chained into each other when all are deployed:
 
 ![overview](./docs/media/rs_addons_s3_overview.png "Overview")

The S3 ACQ wrapper contains the IPFs DDC, L0Pre and L0Post processor as a single step and will process EDRS Sessions into S3 granules. These granules are processed by the L0P processor into S3 L0 products.
 
The following individual NRT processing chains are available:
* [S3 ACQ](./s3-acq/doc/ReleaseNote.md)
* [S3 L0P](./s3-l0p/doc/ReleaseNote.md)
* [S3 OL1](./s3-ol1/doc/ReleaseNote.md)
* [S3 OL1 RAC](./s3-ol1-rac/doc/ReleaseNote.md)
* [S3 OL1 SPC](./s3-ol1-spc/doc/ReleaseNote.md)
* [S3 OL2](./s3-ol2/doc/ReleaseNote.md)
* [S3 MW1](./s3-mw1/doc/ReleaseNote.md)
* [S3 SL1](./s3-sl1/doc/ReleaseNote.md)
* [S3 SL2](./s3-sl2/doc/ReleaseNote.md)
* [S3 SL2 FRP](./s3-sl2-frp/doc/ReleaseNote.md)
* [S3 SR1](./s3-sr1/doc/ReleaseNote.md)
* [S3 SM HY](./s3-sm2-hy/doc/ReleaseNote.md)
* [S3 SM LI](./s3-sm2-li/doc/ReleaseNote.md)
* [S3 SM SI](./s3-sm2-si/doc/ReleaseNote.md)
* [S3 PUG](./s3-pug/doc/ReleaseNote.md)

![overview](./docs/media/rs_addons_s3_ntc_overview.png "NTC Overview")

The following individual NTC processing chains are available:
* [S3 OL1 NTC](./s3-ol1-ntc/doc/ReleaseNote.md)
* [S3 OL2 NTC](./s3-ol2-ntc/doc/ReleaseNote.md)
* [S3 MW1 NTC](./s3-mw1-ntc/doc/ReleaseNote.md)
* [S3 SL1 NTC](./s3-sl1-ntc/doc/ReleaseNote.md)
* [S3 SL2 NTC](./s3-sl2-ntc/doc/ReleaseNote.md)
* [S3 SL2 FRP NTC](./s3-sl2-frp-ntc/doc/ReleaseNote.md)
* [S3 SM2 HY NTC](./s3-sm2-hy-ntc/doc/ReleaseNote.md)
* [S3 SM2 LI NTC](./s3-sm2-li-ntc/doc/ReleaseNote.md)
* [S3 SM2 SI NTC](./s3-sm2-si-ntc/doc/ReleaseNote.md)
* [S3 SR1 NTC](./s3-sr1-ntc/doc/ReleaseNote.md)
* [S3 SY2 NTC](./s3-sy2-ntc/doc/ReleaseNote.md)
* [S3 SY2_AOD NTC](./s3-sy2-aod-ntc/doc/ReleaseNote.md)
* [S3 SY2_VGS NTC](./s3-sy2-vgs-ntc/doc/ReleaseNote.md)
* [S3 PUG NTC](./s3-pug-ntc/doc/ReleaseNote.md)

![overview](./docs/media/rs_addons_s3_stc_overview.png "STC Overview")

The following individual STC processing chains are available:
* [S3 MW1 STC](./s3-mw1-stc/doc/ReleaseNote.md)
* [S3 SM2 HY STC](./s3-sm2-hy-stc/doc/ReleaseNote.md)
* [S3 SM2 LI STC](./s3-sm2-li-stc/doc/ReleaseNote.md)
* [S3 SM2 SI STC](./s3-sm2-si-stc/doc/ReleaseNote.md)
* [S3 SR1 STC](./s3-sr1-stc/doc/ReleaseNote.md)
* [S3 SY2 STC](./s3-sy2-stc/doc/ReleaseNote.md)
* [S3 SY2_VGS STC](./s3-sy2-vgs-stc/doc/ReleaseNote.md)
* [S3 PUG STC](./s3-pug-stc/doc/ReleaseNote.md)

For more information, please consult [https://sentinels.copernicus.eu/web/sentinel/missions/sentinel-3](https://sentinels.copernicus.eu/web/sentinel/missions/sentinel-3)


## Dependencies

In order to work properly the RS Add-ons are requiring a few dependencies that needs to be deployed before hands.

**Infrastructure Layer**

COPRS are using a set of technologies that are utilized by the components. E.g. Kafka, Elasticsearch and MongoDB needs to be available. This infrastructure layer needs to be installed first. For more information on its installation, please consult this [repository](https://github.com/COPRS/infrastructure).

**RS Core Components**
The chain itself will not work without other RS Core components. At least the a Ingestion Chain (for retrieving inputs) and Metadata Extraction (for extracting metadata) needs to be deployed to the cluster. It is also highly recommended to deploy the DLQ as well for a proper error handling.

You can find more information and installation instructions in this [repository](https://github.com/COPRS/production-common).

## Deployment

Each RS Add-on contains a description about the services for the specific processing chain that shall be deployed into the cluster as well as a reference to the docker images that shall be used and a factory default configuration.

In order to deploy a RS Add-on the Ansible scripts from the [infrastructure repository](https://github.com/COPRS/infrastructure) can be used. The following Add-Ons are available for deployment:

### NRT

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-ACQ_<VERSION>.zip \
    -e stream_name=S3_ACQ
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-L0P_<VERSION>.zip \
    -e stream_name=S3_L0P
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-OL1_<VERSION>.zip \
    -e stream_name=S3_OL1
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-OL1-RAC_<VERSION>.zip \
    -e stream_name=S3_OL1_RAC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-OL1-SPC_<VERSION>.zip \
    -e stream_name=S3_OL1_SPC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-OL2_<VERSION>.zip \
    -e stream_name=S3_OL2
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-MW1_<VERSION>.zip \
    -e stream_name=S3_MW1
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SL1_<VERSION>.zip \
    -e stream_name=S3_SL1
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SL2_<VERSION>.zip \
    -e stream_name=S3_SL2
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SL2-FRP_<VERSION>.zip \
    -e stream_name=S3_SL2_FRP
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SR1_<VERSION>.zip \
    -e stream_name=S3_SR1
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SM2-HY_<VERSION>.zip \
    -e stream_name=S3_SM2_HY
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SM2-LI_<VERSION>.zip \
    -e stream_name=S3_SM2_LI
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SM2-SI_<VERSION>.zip \
    -e stream_name=S3_SM2_SI
```

### NTC

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-OL1-NTC_<VERSION>.zip \
    -e stream_name=S3_OL1_NTC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-OL2-NTC_<VERSION>.zip \
    -e stream_name=S3_OL2_NTC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SL1-NTC_<VERSION>.zip \
    -e stream_name=S3_SL1_NTC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SL2-NTC_<VERSION>.zip \
    -e stream_name=S3_SL2_NTC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SL2-FRP-NTC_<VERSION>.zip \
    -e stream_name=S3_SL2_FRP_NTC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SR1-NTC_<VERSION>.zip \
    -e stream_name=S3_SR1_NTC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SM2-HY-NTC_<VERSION>.zip \
    -e stream_name=S3_SM2_HY_NTC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SM2-LI-NTC_<VERSION>.zip \
    -e stream_name=S3_SM2_LI_NTC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SM2-SI-NTC_<VERSION>.zip \
    -e stream_name=S3_SM2_SI_NTC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SY2-NTC_<VERSION>.zip \
    -e stream_name=S3_SY2_NTC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SY2-VGS-NTC_<VERSION>.zip \
    -e stream_name=S3_SY2_VGS_NTC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SY2-AOD-NTC_<VERSION>.zip \
    -e stream_name=S3_SY2_AOD_NTC
```

### STC

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-OL1-STC_<VERSION>.zip \
    -e stream_name=S3_OL1_STC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-OL2-STC_<VERSION>.zip \
    -e stream_name=S3_OL2_STC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SL1-STC_<VERSION>.zip \
    -e stream_name=S3_SL1_STC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SL2-STC_<VERSION>.zip \
    -e stream_name=S3_SL2_STC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SL2-FRP-STC_<VERSION>.zip \
    -e stream_name=S3_SL2_FRP_STC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SR1-STC_<VERSION>.zip \
    -e stream_name=S3_SR1_STC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SM2-HY-STC_<VERSION>.zip \
    -e stream_name=S3_SM2_HY_STC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SM2-LI-STC_<VERSION>.zip \
    -e stream_name=S3_SM2_LI_STC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SM2-SI-STC_<VERSION>.zip \
    -e stream_name=S3_SM2_SI_STC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SY2-STC_<VERSION>.zip \
    -e stream_name=S3_SY2_STC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-SY2-VGS-STC_<VERSION>.zip \
    -e stream_name=S3_SY2_VGS_STC
```

### PUG

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-PUG_<VERSION>.zip \
    -e stream_name=S3_PUG
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-PUG-NTC_<VERSION>.zip \
    -e stream_name=S3_PUG_NTC
```

```
ansible-playbook deploy-rs-addon.yaml \
    -i inventory/mycluster/hosts.ini \
    -e rs_addon_location=https://artifactory.coprs.esa-copernicus.eu/artifactory/rs-zip-private/rs-addons/s3/RS_ADDON_S3-PUG-STC_<VERSION>.zip \
    -e stream_name=S3_PUG_STC
```

For further information on using the deployment script, please consult its [manual](https://github.com/COPRS/infrastructure/blob/e642b4e78782b3e5d649570e4a72b27cb42efeed/doc/how-to/RS%20Add-on%20-%20RS%20Core.md).


## Acroynms

| Abbreviation | Definition |
|---|---|
| COPRS | Copernicus Reference System |
| CPU | Central Processing Unit
| DB | Database |
| DDC | Direct Data Capture |
| EDRS | European Data Relay Satellite |
| IPF | Instrument Processing Facility |
| MWR | Microwave Radiometer |
| L0 | Level-0 |
| L1 | Level-1 |
| L2| Level-2|
| RAM | Random Access Memory |
| RS | Reference System |
| S3 | Sentinel-3 |
| SCDF | Spring Cloud Dataflow |
| SL | Short for SLSTR: Sea and Land Surface Temperature Radiometer |
| SpEL | Sprint Expression Language |
| SR | Short for SRAL: SAR Radar Altimeter |
| SY | Synergy |
| OBS | Object Storage |
| OL | Short for OLCI: Ocean and Land Colour Instrument |



