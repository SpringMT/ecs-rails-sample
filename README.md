# README


## CIAnalyzer schema

```
CREATE EXTERNAL TABLE ci_analysis_tests (
  workflowId string,
  workflowRunId string,
  buildNumber int,
  workflowName string,
  createdAt string,
  branch string,
  service string,
  status string,
  successCount int,
  testSuites struct<
    `name`: string,
    `time`: double,
    tests: int,
    failures: int,
    testsuite: array<
      struct<
        `name`: string,
        `time`: double,
        tests: int,
        failures: int,
        skipped: int,
        `timestamp`: string,
        testcase: array<
          struct<
          classname: string,
          `name`: string,
          `time`: double,
          successCount: int,
          status: string
        >>
      >>
  >
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION 's3://path/to/bucket';
```

