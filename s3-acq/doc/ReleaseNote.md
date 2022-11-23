:arrow_heading_up: Go back to the [Reference System Software repository](https://github.com/COPRS/reference-system-software) :arrow_heading_up:

# RS Add-on - S3 Acquisition

 
 * [RS Add-on S3 Acquisition](#rs-add-on---s3-acquisition)
    * [Overview](#overview)
    * [Requirements](#requirements)
    * [Additional Resources](#additional-resources)
    * [Deployment Prerequisite](#deployment-prerequisite)
    * [Configuration](#configuration)


This add-on contains the configuration for the S3 Acquisition workflow. In the legacy system for this workflow the IPF DDC, L0Pre, L0Post had been performed. As the DDC is however a daemonized system, it is not really compatible with the COPRS styled add-ons.

Thus a wrapper was created to provide a ESA Generic ICD compatible interface for all processors. Thus when a S3 EDRS Session is processed by the system the wrapper will be invoked and processing the data with all three processors.

## Overview

![overview](./media/overview.png "Overview")

The chain will start from the topic catalog event and watching out for new services there. The message filter will ensure that just EDRS sessions and related auxiliary files are consumed by the chain. All other product types will be discard and no processing occurs. Just if the request is not filtered it will be send to the Preparation worker. Its major task is to ensure that all required products for a production are available. 

If the production is not ready yet the request will be persisted and discarded. Once a new relevant product for the chain arrives, it will check again if all required input products are available.

Please note that the S3 RS-Add-ons are not having priority filter. The different timeliness are handled by RS Addon-ons on its own as configuration and workflows can be different for the timeliness. Thus no priority filter is used. Thus one the preparation worker created a job, the execution worker will consume it and executing the processing. In order to increase the amount of products that can be processed in parallel, please scale up the execution workers to have a higher overall throughtput.

For details, please see the applicable [Processing Chain Design](https://github.com/COPRS/production-common/blob/main/docs/architecture/README.md#processing)

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

## Additional Resources 

The preparation worker needs the task table for the IPF wrapped inside of the execution worker. To provide the preparation worker with the needed task table, a configmap will be created by the deployment script based on the file ``tasktable_configmap.yaml``. The resulting configmap contains the task table needed for the S3 ACQ preparation worker, in order to create compatible job orders. 

The config map will be created in kubernetes in the processing namespace and will be named ``s3-acq-tasktables``, to be distinguishable from other tasktable configmaps.

## Configuration

The RS add-on is using a set of generic microservices from the RS Core. The configuration of these configuration parameters are not given within this document, but can be found in the [common documentation](/docs/common/README.md) that is applicable for all RS add-ons.

There are no specific configurations existing for this RS add-on.
