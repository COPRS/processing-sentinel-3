:arrow_heading_up: Go back to the [Reference System Software repository](https://github.com/COPRS/reference-system-software) :arrow_heading_up:

# RS Add-on - S3 PUG

 
 * [RS Add-on S3 PUG](#rs-add-on---s3-pug)
    * [Overview](#overview)
    * [Requirements](#requirements)
    * [Additional Resources](#additional-resources)
    * [Deployment Prerequisite](#deployment-prerequisite)


This add-on contains the configuration for the S3 PUG workflow. It is processing the output from the S3 L0, L1 and L2 production chains and creates the Product Dissemination Units (PDU).

## Overview

![overview](./media/overview.png "Overview")

The chain will start from the topic catalog event and watching out for new services there. The message filter will ensure that just products and related auxiliary files are consumed by the chain. All other product types will be discard and no processing occurs. Just if the request is not filtered it will be send to the Preparation worker. Its major task is to ensure that all required products for a production are available. According to the task table it will check if all required auxiliary files can be found in the catalog via the Metadata Search Controller. Additionally it will verify that all required chunks of the session are ingested into the catalog already as well.

If the production is not ready yet the request will be persisted and discarded. Once a new relevant product for the chain arrives, it will check again if all required input products are available.

Please note that the S3 RS Add-ons are not having priority filter. The different timeliness are handled by RS Add-ons on its own as configuration and workflows can be different for the timeliness. Thus no priority filter is used. Thus one the preparation worker created a job, the execution worker will consume it and executing the processing. In order to increase the amount of products that can be processed in parallel, please scale up the execution workers to have a higher overall throughtput.

For details, please see [Processing Chain Design](https://github.com/COPRS/production-common/blob/develop/docs/architecture/README.md#processing)

## Requirements

This software does have the following minimal requirements:

| Resource                    | Execution Worker* |
|-----------------------------|-------------|
| CPU                         | 7000m       |
| Memory                      | 50Gi        |
| Disk volume needed          | yes         |
| Disk access                 | ReadWriteOnce |
| Disk storage capacity       | 220Gi **    |
| Affinity between Pod / Node | N/A         |
|                             |             |

*These resource requirements are applicable for one worker. There may be many instances of workers, see scaling up workers for more details.
** This amount had been used in previous operational environment. The disk size might be lower depending on the products that are processed. This needs to be at least twice of the product size of the biggest product. An additional margin of 10% is recommended however.

## Known limitations

The original tasktables extracted from the PUG CFI are not in the format that is expected by the COPRS software. Thus the tasktables had been altered manually to be in line with the expectation.

Please keep this in mind when using a new version of the PUG CFI. It is required to change the element `<file_type>` to "`<type>` for outputs types. E.g. change the following finding:

```
			   <Output>
                  <Destination>PROC</Destination>
                  <Mandatory>Yes</Mandatory>
                  <File_Type>OL_0_EFRINT</File_Type>
                  <File_Name_Type>Directory</File_Name_Type>
                </Output>
                <Output>
                  <Destination>PROC</Destination>
                  <Mandatory>Yes</Mandatory>
                  <File_Type>PDUStatistics</File_Type>
                  <File_Name_Type>Directory</File_Name_Type>
                </Output>
```
   
to:

```
                <Output>
                  <Destination>PROC</Destination>
                  <Mandatory>Yes</Mandatory>
                  <Type>OL_0_EFRINT</Type>
                  <File_Name_Type>Directory</File_Name_Type>
                </Output>
                <Output>
                  <Destination>PROC</Destination>
                  <Mandatory>Yes</Mandatory>
                  <Type>PDUStatistics</Type>
                  <File_Name_Type>Directory</File_Name_Type>
                </Output>
```

## Additional Resources 

The preparation worker needs the task table for the IPF wrapped inside of the execution worker. To provide the preparation worker with the needed task table, a configmap will be created by the deployment script based on the file ``tasktable_configmap.yaml``. The resulting configmap contains the task tables needed for the S3 PUG preparation worker, in order to create compatible job orders. 

The config map will be created in kubernetes in the processing namespace and will be named ``s3-pug-tasktables``, to be distinguishable from other tasktable configmaps.

Additionally the S3 PUG chain needs a second configmap ``joborderxslt_configmap.yaml``. This configmap contains an xslt-file to convert the produced JobOrder to be compatible with the Sentinel-3 IPF.

This config map will be created in kubernetes in the processing namespace and will be named ``s3-pug-joborderxslt``, to be distinguishable from other tasktable configmaps.

## Deployment Prerequisite

In order to operate this RS add-on there are some dependencies that needs to be deployed beforehand. For additional information, please consult the [common configuration](/common/README.md#deployment-prerequisite).

## Configuration

The RS add-on is using a set of generic microservices from the RS Core. The configuration of these configuration parameters are not given within this document, but can be found in the [common documentation](/common/README.md) that is applicable for all RS add-ons.

There are no specific configurations existing for this RS add-on.

