:arrow_heading_up: Go back to the [Reference System Software repository](https://github.com/COPRS/reference-system-software) :arrow_heading_up:

# Common Configuration Documentation

## Purpose

The purpose of the following sections is to give an overview about the configuration parameters that are used across all the RS Add-ons of this repository. Each repository is using a set of generic microservices that can be found in the [Production Common repository](https://github.com/COPRS/production-common).

Each RS Add-on just uses a specific configuration of these generic components. To avoid a duplication of the configuration the common parameters are explained in this document. Please check the specific RS add-on for specific information on the RS Add-On.

## Deployment Prerequisite

Following components of the COPRS shall be installed and running
- [COPRS Infrastructure](https://github.com/COPRS/infrastructure)
OBS Buckets, Kubernetes Secrets and ES indices shall be created.
- See [COPRS OBS Bucket](https://github.com/COPRS/production-common/blob/main/processing-common/doc/buckets.md)
- See [COPRS Kubernetes Secret](https://github.com/COPRS/production-common/blob/main/processing-common/doc/secret.md)
- See [COPRS Search Controller](https://github.com/COPRS/production-common/tree/main/rs-processing-common)

The RS Add-ons are also having the component Preparation worker that is persisting existing jobs that are not ready to run (e.g. missing inputs). In order to work correctly it will require MongoDB as persistence layer. For further general information regarding the creation of a secret for the  MongoDB instance, please see [COPRS MongoDB](https://github.com/COPRS/production-common/blob/main/processing-common/doc/secret.md)

The default configuration provided in the RS Core Component is expecting a secret "mongopreparation" in the namespace "processing" containing a field for PASSWORD and USERNAME that can be used in order to authenticate at the MongoDB.

Please note that further initialization might be required. For the Preparation worker component please execute the following commands in the MongoDB in order to create the credentials for the secret:

```
db.createUser({user: "<USER>", pwd: "<PASSWORD>", roles: [{ role: "readWrite", db: "coprs" }]})
db.sequence.insert({_id: "appDataJob",seq: 0});
db.appDataJob.createIndex({"_id":1, "generation.taskTable":1}) 
db.appDataJob.createIndex({"state":1, "generation.state":1, "generation.taskTable":1})
```

Be aware that also the creation of the indices are very important to ensure that the queries on the Mongo database are fast even if lots of requests are within the system.

## Configuration Parameters

### Overview
The following sections are giving an overview about common components that are used within the processing chains defined within the RS add-ons.

Please note that depending on the component the name of the parameters are varying. In general the configuraton parameter will match the pattern `app.<component-name>.<parameter>`. The string `app` ist static and a requirement for SCDF and is always present. 

`component-name` represent the name of the specific component that is configured. Consult the `stream-definition.properties` file of the specific RS add-on in order to get the names of the component. So for example `preparation-worker` or `message-filter` are the name of the components.

The name  of the `parameter` are the actual configuration and can be taken from the tables given below in order to configure a specific behaviour of the processing chain.

### Processing Filter

Each RS Add-on can have two different kind of filters:
* A filter used as a gate to decide what products shall be processed (``message-filter``)
* Multiple filters that decides upon the priority of the event (``priority-filter-<high|medium|low>``)

Please note that the priority filter might not be used when there is no specific requirement on handling the different timeliness within the chain itself or if there are specific RS add-ons to handle the timeliness because of different configuration or workflows. 

The message filter is always existing to ensure that the chain just consumes products it is supposed to be processing

| Property                   				                               | Details       |
|---------------------------------------------------------------|---------------|
|``app.message-filter.filter.function.expression``| A [SpEL](https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/expressions.html) expression that will be performed on the event to decide if the event is applicable for a compression. E.g. for Sentinel-1 the filter configuration using productFamily and keyObjectStorage name of the product could be like: ``((payload.productFamily == 'EDRS_SESSION') && (payload.missionId == 'S1')) || (payload.productFamily == 'AUXILIARY_FILE')``| 
|``app.priority-filter-high.filter.function.expression``| A [SpEL](https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/expressions.html) expression defining what request are supposed to be handled by the high priority chain. E.g. handling all S1 events with FAST24 timeliness: ``payload.timeliness == 'PT'``| 
|``app.priority-filter-medium.filter.function.expression``| A [SpEL](https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/expressions.html) expression defining what request are supposed to be handled by the medium priority chain. E.g. handling all S1 events with NRT timeliness. ``payload.timeliness == 'NRT'``| 
|``app.priority-filter-low.filter.function.expression``|  [SpEL](https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/expressions.html) expression defining what request are supposed to be handled by the low priority chain. E.g. handling all events that are not having a timeliness: ``(payload.timeliness != 'PT') && (payload.timeliness != 'NRT')``| 

### Preparation Worker

The preparation worker is used in all Sentinel-1 and Sentinel-3 RS add-on processing chains. The configuration is compounded by two different parts: A generic configuration that defines the interface with other systems (e.g. databases) and one containing the specific logic of the processing that shall be applied by the chain.

Please note that the preparation worker is a generic component and thus some parameters can be applied everywhere, but just make sense in specific workflows. E.g. functions for Sentinel-1 doesn't make sense to be used in Sentinel-3. Be aware that not all combinations will result in the expected behaviour. Each RS add-on is providing however a factory default configuration that provides a working example of how a specific component needs to be configured in order to work with the generic components.

#### Generic configuration part

##### MongoDB Connection

| Property | Details |
|----------|---------|
| ``app.preparation-worker.mongodb.host`` | Hostname to connect to the MongoDB (default: ``mongodb-0.mongodb-headless.database.svc.cluster.local``) |
| ``app.preparation-worker.mongodb.port`` | Port to connect to the MongoDB (default: ``27017``) |
| ``app.preparation-worker.mongodb.database`` | Name of the database to use inside of MongoDB (default: ``coprs``) |
| ``app.preparation-worker.mongodb.username`` | Username to query and update documents in the MongoDB (default: ``${MONGO_USERNAME}``, Environment variable extracted from the secret ``mongoprepration``) |
| ``app.preparation-worker.mongodb.password`` | Password for the user to query and update documents in the MongoDB (default: ``${MONGO_PASSWORD}``, Environment variable extracted from the secret ``mongoprepration``) |

##### Prometheus Metrics Configuration

The preparation-worker application exposes a Gauge metric ``rs_pending_processing_job`` on the ``actuator/prometheus`` endpoint (if activated).
This metric includes some tags in order to differenciate the different preparation-worker metrics from another.
This configuration section includes the values for the different tags.

| Property | Details |
|----------|---------|
| ``app.preparation-worker.metrics.mission`` | Value for the tag ``mission`` |
| ``app.preparation-worker.metrics.level`` | Value for the tag ``level`` |
| ``app.preparation-worker.metrics.addonName`` | Value for the tag ``addonName`` |

##### Metadata Search Controller Connection

| Property | Details |
|----------|---------|
| ``app.preparation-worker.metadata.metadataHostname`` | Hostname and port to connect to the search controller (default: ``rs-metadata-catalog-searchcontroller-svc:8080``) |
| ``app.preparation-worker.metadata.nbretry`` | Number of retries, when a query fails (default: ``3``) |
| ``app.preparation-worker.metadata.temporetryms`` | Timeout between retries in milliseconds (default: ``1000``) |
| ``app.preparation-worker.metadata.valintersectnoduplicatesworkaround`` | Allows to activate the workaround for the selection policy ValIntersectWithoutDuplicates that will replace it with ValIntersect during the startup. By default this is deactivated (default: ``false``) |

##### Process Configuration 

| Property | Details |
|----------|---------|
| ``app.preparation-worker.process.level`` | Process level for the preparation worker. Controls level specific logic. For S1 AIOP and S3 ACQ: ``L0`` |
| ``app.preparation-worker.process.mode`` | Process mode for the preparation worker. Allowed values: ``PROD``, ``TEST`` (default: ``PROD``) |
| ``app.preparation-worker.process.hostname`` | Hostname of the preparation worker (default: ``${HOSTNAME}``) |
| ``app.preparation-worker.process.productType`` | ProductType of main inputs. Used for logging/reporting (default: ``EdrsSession``) |
| ``app.preparation-worker.process.loglevelstdout`` | LogLevel for stdout of the IPF process wrapped in the execution worker (default: ``INFO``) |
| ``app.preparation-worker.process.loglevelstderr`` | LogLevel for stderr of the IPF process wrapped in the execution worker (default: ``INFO``) |
| ``app.preparation-worker.process.processingstation`` | Processing Station (default: ``WILE``) |
| ``app.preparation-worker.process.params`` | Dynamic processing parameters for the job order. Contains a map of key value pairs |
| ``app.preparation-worker.process.outputregexps`` | Map to match regular expressions to output file types. Key: output file type, Value: regular expression used for file names |

##### Worker Configuration

| Property | Details |
|----------|---------|
| ``app.preparation-worker.worker.diroftasktables`` | Directory, where the tasktables can be found (default: ``/app/tasktables``) |
| ``app.preparation-worker.worker.maxnboftasktable`` | Number of task tables. For S1 AIOP: ``1`` |
| ``app.preparation-worker.worker.defaultfamily`` | Default ProductFamily for product types not found in inputfamilies or outputfamilies (default: ``BLANK``) |
| ``app.preparation-worker.worker.inputfamiliesstr`` | Key-Value pairs of mappings of product types to ProductFamily for input product types |
| ``app.preparation-worker.worker.outputfamiliesstr`` | Key-Value pairs of mappings of product types to ProductFamily for output product types |
| ``app.preparation-worker.worker.type-overlap`` | Map of all overlap for different slice types in Sentinel-1 |
| ``app.preparation-worker.worker.type-slice-length`` | Map of all lengths for different slice types in Sentinel-1 |
| ``app.preparation-worker.worker.map-type-meta`` | Map for product types to corresponding metadata indexes, if the product type itself is not the same as the index |
| ``app.preparation-worker.worker.product-mode`` | Mode for this preparation-worker, defining which inputs of the task tables are applicable |
| ``app.preparation-worker.worker.pathTaskTableXslt`` | Path to the taskTableXslt (if applicable), which should be applied to the tasktables before reading them |
| ``app.preparation-worker.worker.primaryCheckMaxTimelifeS`` | Maximum waiting time for the main input search |

##### Tasktable Configuration

| Property | Details |
|----------|---------|
| ``app.preparation-worker.tasktable.routingKeyTemplate`` | Template how to match incoming messages onto the routing mapping configured in ``routing``. For S1 AIOP: ``${product.productType}`` |
| ``app.preparation-worker.tasktable.routing`` | Map to determine tasktable to use for an incoming message, to create new AppDataJobs for the preparation worker |


#### Product type specific configuration part

##### AIOP and ACQ Configuration

The following properties are required for EDRS sessions and are applicable for the S1 AIOP as well as the S3 ACQ workflow and required in both cases. Check the specific RS add-ons for getting an idea how to use these properties correctly for these scenarios.

| Property | Details |
|----------|---------|
| ``app.preparation-worker.aiop.station-codes`` | Map for the station codes. Used to compound all map-properties below. |
| ``app.preparation-worker.aiop.pt-assembly`` | Map for property values for each station code to fill JobOrder Parameter ``PT_Assembly`` |
| ``app.preparation-worker.aiop.processing-mode`` | Map for property values for each station code to fill JobOrder Parameter ``Processing_Mode`` |
| ``app.preparation-worker.aiop.reprocessing-mode.`` | Map for property values for each station code to fill JobOrder Parameter ``Reprocessing_Mode`` |
| ``app.preparation-worker.aiop.timeout-sec`` | Map for property values for each station code to fill JobOrder Parameter ``TimeoutSec`` |
| ``app.preparation-worker.aiop.descramble`` | Map for property values for each station code to fill JobOrder Parameter ``Descramble`` |
| ``app.preparation-worker.aiop.rs-encode`` | Map for property values for each station code to fill JobOrder Parameter ``RSEncode`` |
| ``app.preparation-worker.aiop.minimal-waiting-time-sec`` | Determines how long a job should wait before running into a timeout in seconds (currently not used) (default: ``360000``) |
| ``app.preparation-worker.aiop.nrt-output-path`` | Value for dynamic processing parameter ``NRTOutputPath`` (default: ``/data/localWD/%WORKING_DIR_NUMBER%/NRT``). ``%WORKING_DIR_NUMER%`` will be replaced by the actual working directory number for the JobOrder |
| ``app.preparation-worker.aiop.pt-output-path`` | Value for dynamic processing parameter ``PTOutputPath`` (default: ``/data/localWD/%WORKING_DIR_NUMBER%/PT``). ``%WORKING_DIR_NUMER%`` will be replaced by the actual working directory number for the JobOrder |

#### ASP Configuration

| Property | Details |
|----------|---------|
| ``app.preparation-worker.l0asp.waiting-time-hours-minimal-fast`` | Timeout configuration. Currently not used. Jobs shall at longest wait for the maximum of sensingStopTime + nominal and jobCreationTime + minimal (default: ``1``) |
| ``app.preparation-worker.l0asp.waiting-time-hours-nominal-fast`` | Timeout configuration. Currently not used. Jobs shall at longest wait for the maximum of sensingStopTime + nominal and jobCreationTime + minimal (default: ``36``) |
| ``app.preparation-worker.l0asp.waiting-time-hours-minimal-nrt-pt`` | Timeout configuration. Currently not used. Jobs shall at longest wait for the maximum of sensingStopTime + nominal and jobCreationTime + minimal (default: ``1``) |
| ``app.preparation-worker.l0asp.waiting-time-hours-nominal-nrt-pt`` | Timeout configuration. Currently not used. Jobs shall at longest wait for the maximum of sensingStopTime + nominal and jobCreationTime + minimal (default: ``36``) |

#### S3TypeAdapter Configuration

| Property | Details |
|----------|---------|
| ``app.preparation-worker.s3-type-adapter.mpc-search.<product_type>.product-types`` | List of Product Types to apply the MultipleProductCoverSearch Extension for Sentinel-3 on |
| ``app.preparation-worker.s3-type-adapter.mpc-search.<product_type>.gap-threshold`` | Threshhold in seconds, defining when a gap is big enough to be recognized as a gap and therefor signaling, that the currently found products are not enough to cover the interval |
| ``app.preparation-worker.s3-type-adapter.mpc-search.<product_type>.disable-first-last-waiting`` | Boolean flag to diable the waiting mechanism on the first and last granule of an orbit. |
| ``app.preparation-worker.s3-type-adapter.range-search.<product_type>.product-type`` | Product Type to perform the RangeCover logic on. Ths logic is currently only used for the VISCAL product. |
| ``app.preparation-worker.s3-type-adapter.range-search.<product_type>.anx-offset-in-s`` | Offset in seconds regarding the ANX time of the orbit to calculate bounds for product |
| ``app.preparation-worker.s3-type-adapter.range-search.<product_type>.range-length-in-s`` | Length of the interval in seconds |
| ``app.preparation-worker.s3-type-adapter.olci-calibration`` | List of processors on which the OLCI Calibration logic shall be executed |
| ``app.preparation-worker.s3-type-adapter.dyn-proc-params`` | Map of static key value pairs, that should be added to JobOrder |
| ``app.preparation-worker.s3-type-adapter.optional-outputs.<product_type>`` | List of optional outputs of tasktable, that shall be produced. |

#### PUG Configuration

| Property | Details |
|----------|---------|
| ``app.preparation-worker.pdu.config.<product_type>.type`` | Type of the PDU for the given product type. Default: FRAME. Allowed values: FRAME, STRIPE, TILE |
| ``app.preparation-worker.pdu.config.<product_type>.reference`` | Reference point for length and offset for PDU generation. Default: ORBIT. Allowed values: DUMP, ORBIT |
| ``app.preparation-worker.pdu.config.<product_type>.length-in-s`` | Length of PDUs to be created. Double value. |
| ``app.preparation-worker.pdu.config.<product_type>.offset-in-s`` | Offset of the start from the reference point. Double value |
| ``app.preparation-worker.pdu.config.<product_type>.gap-threshhold-in-s`` | Thresshold for the gap handler to determine if two products are handled as continuous |
| ``app.preparation-worker.pdu.config.<product_type>.dyn-proc-params`` | Map of static values for the dynamic processing parameters on the job order |

#### S3Synergy Configuration

| Property | Details |
|----------|---------|
| ``app.preparation-worker.s3-synergy.dyn-proc-params`` | Map of static values for the dynamic processing parameters on the job order |


### Housekeeping

The Housekeeping service does have the same configuration as the Preparation Worker, in order for timeout jobs to be correctly composed. In order for the housekeeping mechanism to function properly the following properties have to be set additionally:

| Property | Details |
|----------|---------|
| ``app.housekeep.spring.cloud.stream.function.definition`` | Has to be set to the value ``houseKeepAppDataJobs`` |
| ``app.housekeep.worker.maxAgeJobMs`` | List of timeouts, when to delete old jobs from the system. Timeout is configured in milliseconds and seperately for each of the possible AppDataJobState: ``waiting``, ``dispatching``, ``generating``, ``terminated``. The most important ones to configure are ``generating`` and ``terminated``. Default: 604800000 (7 days) |
| ``app.time.spring.integration.poller.fixed-rate`` | Configuration how often the housekeeping mechanism should be triggered (how often the Housekeeper should check the database for old jobs and timeout jobs). Default: 60s |

## Cronbased-Trigger

The Cronbased-Trigger service is responsible to check the MetadataSearchController if there are any new products generated since the last execution. This application has a configurable cron expression to adjust the load on the system by adjusting the timings the STC and NTC workflows are performed. 

| Property | Details |
|----------|---------|
| ``app.trigger.spring.cloud.stream.function.bindings.cronbasedTrigger-in-0`` | Has to be set to the value ``input`` |
| ``app.trigger.spring.cloud.stream.function.bindings.cronbasedTrigger-out-0`` | Has to be set to the value ``output`` |
| ``app.trigger.spring.cloud.stream.function.definition`` | Has to be set to the value ``cronbasedTrigger`` |
| ``app.trigger.mongodb.host`` | Host for the MongoDB Connection. Default: ``mongodb-0.mongodb-headless.database.svc.cluster.local`` |
| ``app.trigger.mongodb.port`` | Port for the MongoDB Connection. Default: ``27017`` |
| ``app.trigger.mongodb.database`` | Database to use for the MongoDB Connection. Default: ``coprs`` |
| ``app.trigger.mongodb.username`` | Username for the MongoDB Connection. Default: ``${MONGO_USERNAME}`` |
| ``app.trigger.mongodb.password`` | Password for the MongoDB Connection. Default: ``${MONGO_PASSWORD}`` |
| ``app.trigger.metadata.metadataHostname`` | Hostname and Port for the MetadataSearchController. Default: ``rs-metadata-catalog-searchcontroller-svc:8080`` |
| ``app.trigger.metadata.nbretry`` | Retries performed while querying the MetadataSearchController. Default: ``3`` |
| ``app.trigger.metadata.temporetryms`` | Timeout between Retries while queryable. Default: ``1000`` |
| ``app.trigger.trigger.pod`` | Static name to identify entries in the database. Default: ```` |
| ``app.trigger.trigger.config.<productType>.cron`` |  Default: ``0 */15 * * * *`` |
| ``app.trigger.trigger.config.<productType>.family`` | Default: ``S3_PUG`` |
| ``app.trigger.trigger.config.<productType>.satelliteIds`` | Default: ``A,B`` |

### Execution Worker

Note that the execution worker might have in some context a priority filter before and multiple instances might be existing within the chain:

* app.execution-worker-high
* app.execution-worker-medium
* app.execution-worker-low

The configuration for the different execution workers are usually the same however. This is required in order to handle the different timeliness within the processing chains and allows to scale the different timeliness independently from each other.

The examples in the following sections are just giving the configuration parameters for the high priority workers. They are the same for all Execution Workers however.

#### Important SCDF Properties

| Property | Details |
|----------|---------|
| ``app.execution-worker-high.spring.cloud.stream.kafka.bindings.input.consumer.configuration.max.poll.records`` | Number of records that are pulled in batch when retrieving new messages for the kafka consumer. Tests have shown, that for reliable processing this property shall be set to ``1`` |
| ``app.execution-worker-high.spring.cloud.stream.kafka.bindings.input.consumer.configuration.max.poll.interval.ms`` | Number of milliseconds how long the processing of one kafka message shall take, before consumer is kicked from consumer group by the kafka broker. This property is very important for the processing of long-running tasks. |

#### Process Configuration

| Property | Details |
|----------|---------|
| ``app.execution-worker-high.process.level`` | Process level for the execution worker. Controls level specific logic. For S1 AIOP: ``L0`` |
| ``app.execution-worker-high.process.hostname`` | Hostname of the execution worker (default: ``${HOSTNAME}``) |
| ``app.execution-worker-high.process.workingDir`` | Working directory for the execution worker. Location where the currently processed AppDataJob will be saved (default: ``/data/localWD``) |
| ``app.execution-worker-high.process.tm-proc-stop-s`` | Seconds how long the cleaning of a JobProcessing may take in seconds (default: ``300``) |
| ``app.execution-worker-high.process.tm-proc-one-task-s`` | Seconds how long one task is allowed to run for in seconds (default: ``600``) |
| ``app.execution-worker-high.process.tm-proc-all-tasks-s`` | Seconds how long all tasks at sum are allowed to run for in seconds (default: ``7200``) |
| ``app.execution-worker-high.process.size-batch-upload`` | Number of outputs, that should be uploaded in parallel (default: ``2``) |
| ``app.execution-worker-high.process.size-batch-download`` | Number of inputs, that should be downloaded in parallel (default: ``10``) |
| ``app.execution-worker-high.process.wap-nb-max-loop`` | Number of retries when checking if process is active (default: ``12``) |
| ``app.execution-worker-high.process.wap-tempo-s`` | Seconds how long to wait between each check if process is active (default: ``10``) |
| ``app.execution-worker-high.process.threshold-ew`` | Threshold for length to determine if a file is a ghost candidate for polarisation EW (default: ``3``) |
| ``app.execution-worker-high.process.threshold-iw`` | Threshold for length to determine if a file is a ghost candidate for polarisation IW (default: ``3``) |
| ``app.execution-worker-high.process.threshold-sm`` | Threshold for length to determine if a file is a ghost candidate for polarisation SM (default: ``3``) |
| ``app.execution-worker-high.process.threshold-wv`` | Threshold for length to determine if a file is a ghost candidate for polarisation WV (default: ``30``) |
| ``app.execution-worker-high.process.productTypeEstimationEnabled`` | Enables estimated count for outputs  dependent on product types (default: false) |
| ``app.execution-worker-high.process.productTypeEstimationOutputFamily``| Product Family of output type, e.g. S3_GRNULES for Sentinel-3 ACQ processing or L0_SEGMENT for Sentinel-1 AIOP processing |
| ``app.execution-worker-high.process.productTypeEstimatedCount.<typX>.regexp``| Regular expression matching the output product type, e.g. OL_0_EFR__G.  The paramter ``count`` is configured to be the count of types matching this regex |
| ``app.execution-worker-high.process.productTypeEstimatedCount.<typX>.count`` | Number of outputs estimated fot the specified regex |
| ``app.preparation-worker.process.l0EwSlcCheckPattern`` |  EW-SLC mask intersection check configuration. Files with names matching this pattern are checked (only if also the name of the tasktable in use matches with value of next configuration property). If not set, default is ``$a`` that means no check is performed and all files will be processed. Example: ``^S1[AB]_EW_RAW__0S.*\.SAFE$`` |
| ``app.preparation-worker.process.l0EwSlcTaskTableName`` | EW-SLC mask intersection check configuration. The name of the tasktable in use needs to match with configured value in order to perform the check (only if also the file name handled matches the configured pattern of previous property). Default: EW_RAW__0_SLC |
| ``app.preparation-worker.process.l0EwSlcMaskFilePath`` | EW-SLC mask intersection check configuration. Path to the mask file in EOF format. If not set, no check is performed and all files will be processed. Example: /shared/sentinel1/masks/S1__OPER_MSK_EW_SLC_V20140427T000000_G20210108T170000.EOF|
| ``app.preparation-worker.process.seaCoverageCheckPattern`` | Sea coverage check configuration. Files with names matching this pattern are checked. If not set, default is ``$a`` that means no check is performed and all files will be processed. Example: ``^S1[A-D]_(IW\|EW\|S[1-6])_RAW__0S.*`` |
| ``app.preparation-worker.process.minSeaCoveragePercentage`` | Sea coverage check configuration. Possible values: 0 to 100. Configuration of minimum percentage of area of the product that is over sea that is used to decide if the product will be processed. When set to 0 (default) a sea coverage > 0 will be regarded as over sea. If set to 100 only products with full sea coverage will be processed.   |
| ``app.preparation-worker.process.landMaskFilePath`` | Sea coverage check configuration. Path to the mask file in EOF format. If not set, no check is performed and all files will be processed. Example: /shared/sentinel1/masks/S1__OPER_MSK__LAND__V20140403T210200_G20200914T080808.EOF|

#### Development Configuration

| Property | Details |
|----------|---------|
| ``app.execution-worker-high.dev.stepsActivation.download`` | Switch to determine whether or not inputs shall be downloaded (default: ``true``) |
| ``app.execution-worker-high.dev.stepsActivation.upload`` | Switch to determine whether or not outputs shall be uploaded (default: ``true``) |
| ``app.execution-worker-high.dev.stepsActivation.erasing`` | Switch to determine whether or not the working directory shall be deleted (default: ``true``) |

### Deployer properties

The following table only contains a few properties used by the factory default configuration. For more information please refer to the [official documentation](https://docs.spring.io/spring-cloud-dataflow/docs/current/reference/htmlsingle/#configuration-kubernetes-deployer) or COPRS-ICD-ADST-001139201 - ICD RS core.
  
| Property | Details |
|-|-|
| `deployer.<application-name>.kubernetes.namespace` | Namespace to use | 
| `deployer.<application-name>.kubernetes.livenessProbeDelay` | Delay in seconds when the Kubernetes liveness check of the app container should start checking its health status. | 
| `deployer.<application-name>.kubernetes.livenessProbePeriod` | Period in seconds for performing the Kubernetes liveness check of the app container. | 
| `deployer.<application-name>.kubernetes.livenessProbeTimeout` | Timeout in seconds for the Kubernetes liveness check of the app container. If the health check takes longer than this value to return it is assumed as 'unavailable'. | 
| `deployer.<application-name>.kubernetes.livenessProbePath` | Path that app container has to respond to for liveness check. | 
| `deployer.<application-name>.kubernetes.livenessProbePort` | Port that app container has to respond on for liveness check. | 
| `deployer.<application-name>.kubernetes.readinessProbeDelay` | Delay in seconds when the readiness check of the app container should start checking if the module is fully up and running. | 
| `deployer.<application-name>.kubernetes.readinessProbePeriod` | Period in seconds to perform the readiness check of the app container. | 
| `deployer.<application-name>.kubernetes.readinessProbeTimeout` | Timeout in seconds that the app container has to respond to its health status during the readiness check. | 
| `deployer.<application-name>.kubernetes.readinessProbePath` | Path that app container has to respond to for readiness check. | 
| `deployer.<application-name>.kubernetes.readinessProbePort` | Port that app container has to respond on for readiness check. | 
| `deployer.<application-name>.kubernetes.limits.memory` | The memory limit, maximum needed value to allocate a pod, Default unit is mebibytes, 'M' and 'G" suffixes supported | 
| `deployer.<application-name>.kubernetes.limits.cpu` | The CPU limit, maximum needed value to allocate a pod | 
| `deployer.<application-name>.kubernetes.requests.memory` | The memory request, guaranteed needed value to allocate a pod. | 
| `deployer.<application-name>.kubernetes.requests.cpu` | The CPU request, guaranteed needed value to allocate a pod. | 
| `deployer.<application-name>.kubernetes.maxTerminatedErrorRestarts` | Maximum allowed restarts for app that fails due to an error or excessive resource use. | 
| `deployer.<application-name>.kubernetes.environmentVariables` | Can be used to pass additional environmental variables into the application.<br> This can be used for example to set JVM specific arguments to use 512m. The example given shows how the XMX argument can be set: JAVA_TOOL_OPTIONS=-Xmx512m <br> For further information, please consult [this](https://docs.spring.io/spring-cloud-dataflow/docs/current/reference/htmlsingle/#_environment_variables) page. |
| `deployer.<application-name>.kubernetes.podSecurityContext` | Can be used to change which user shall be used to execute commands inside of the SCDF application | `deployer.<application-name>.kubernetes.secretKeyRefs` | Mappings to retrieve values from kubernetes secrets and provide them in the container as environment variables |
| `deployer.<application-name>.kubernetes.volumeMounts` | List of volume mounts. Contains information of the name of volume and where inside the container the volume shall be mounted |
| `deployer.<application-name>.kubernetes.volumes` | List of volumes. Contains information regarding the type and name of the volume |

Please note that it will be required to setup certain deployer properties like imagePullSecrets or hardware requirement for the different workers individually. The configuration items are the same as described above however.
